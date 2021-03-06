package ca.uwaterloo.cs.ldbc.interactive.gremlin.handler;

import ca.uwaterloo.cs.ldbc.interactive.gremlin.Entity;
import ca.uwaterloo.cs.ldbc.interactive.gremlin.GremlinDbConnectionState;
import ca.uwaterloo.cs.ldbc.interactive.gremlin.GremlinUtils;
import com.ldbc.driver.DbConnectionState;
import com.ldbc.driver.DbException;
import com.ldbc.driver.OperationHandler;
import com.ldbc.driver.ResultReporter;
import com.ldbc.driver.workloads.ldbc.snb.interactive.LdbcQuery4;
import com.ldbc.driver.workloads.ldbc.snb.interactive.LdbcQuery4Result;
import org.apache.tinkerpop.gremlin.driver.Client;
import org.apache.tinkerpop.gremlin.driver.Result;
import org.joda.time.DateTime;

import java.util.*;
import java.util.concurrent.ExecutionException;

public class LdbcComplexQuery4Handler implements OperationHandler<LdbcQuery4, DbConnectionState> {
    @Override
    public void executeOperation(LdbcQuery4 ldbcQuery4, DbConnectionState dbConnectionState, ResultReporter resultReporter) throws DbException {
        // Description: Given a start Person, find Tags that are attached to Posts that were created by that Person's friends.
        // Only include Tags that were attached to friends' Posts created within a given time interval, and that were never
        // attached to friends' Posts created before this interval.
        // * Parameters:
        // Person.id ID
        // startDate Date
        // duration 32-bit Integer
        // * Results:
        // Tag.name String
        // count 32-bit Integer
        // * Sort:
        // 1st count (descending)
        // 2nd Tag.name (ascending)
        // * Limit: 10
        // duration of requested period, in days
        // the interval [startDate, startDate + Duration) is closed-open
        // number of Posts made within the given time interval that have this Tag

        Client client = ((GremlinDbConnectionState) dbConnectionState).getClient();
        Map<String, Object> params = new HashMap<>();
        params.put("person_id", GremlinUtils.makeIid(Entity.PERSON, ldbcQuery4.personId()));
        params.put("person_label", Entity.PERSON.getName());
        params.put("post_label", Entity.POST.getName());
        Date start = ldbcQuery4.startDate();
        Date end = new DateTime( start ).plusDays( ldbcQuery4.durationDays() ).toDate();
        params.put("start_date", start.getTime());
        params.put("end_date", end.getTime());
        params.put("result_limit", ldbcQuery4.limit());

        String statement = "g.V().has(person_label, 'iid', person_id).out('knows')" +
            ".in('hasCreator').hasLabel(post_label).as('friend_posts')" +
            ".sideEffect(has('creationDate',lt(start_date)).out('hasTag').aggregate('before_tags'))"+
            ".has('creationDate', inside(start_date, end_date))" +
            ".out('hasTag')" +
            ".is(without('before_tags'))" +
            ".groupCount().by('name')" +
            ".order(local).by(values, decr).by(keys)" +
            ".limit(local, result_limit)";
        /*
        g.V().has('person', 'iid', 'person:10995116278092').out('knows').
        in('hasCreator').as('friend_posts').
        has('creationDate', inside(1275350400000,1975350400000 )).
        out('hasTag').
        is(without('before_tags')).
        groupCount().by('name').
        order(local).by(values, decr).
        limit(local, 10)
        */
        List<Result> results;
        try {
            results = client.submit(statement, params).all().get();
        } catch (InterruptedException | ExecutionException e) {
            throw new DbException("Remote execution failed", e);
        }

        HashMap<String, Long> resultMap = results.get(0).get(HashMap.class);

        List<LdbcQuery4Result> resultList = new ArrayList<>();
        for (HashMap.Entry<String, Long> entry : resultMap.entrySet()) {
            String tagName = entry.getKey();
            int tagCount = Math.toIntExact(entry.getValue());

            resultList.add(new LdbcQuery4Result(tagName, tagCount));
        }
        resultReporter.report(resultList.size(), resultList, ldbcQuery4);
    }
}
