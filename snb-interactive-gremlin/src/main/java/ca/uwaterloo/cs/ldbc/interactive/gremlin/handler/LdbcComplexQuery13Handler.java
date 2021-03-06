package ca.uwaterloo.cs.ldbc.interactive.gremlin.handler;

import ca.uwaterloo.cs.ldbc.interactive.gremlin.Entity;
import ca.uwaterloo.cs.ldbc.interactive.gremlin.GremlinDbConnectionState;
import ca.uwaterloo.cs.ldbc.interactive.gremlin.GremlinUtils;
import com.ldbc.driver.DbConnectionState;
import com.ldbc.driver.DbException;
import com.ldbc.driver.OperationHandler;
import com.ldbc.driver.ResultReporter;
import com.ldbc.driver.workloads.ldbc.snb.interactive.LdbcQuery13;
import com.ldbc.driver.workloads.ldbc.snb.interactive.LdbcQuery13Result;
import org.apache.tinkerpop.gremlin.driver.Client;
import org.apache.tinkerpop.gremlin.driver.Result;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

/**
 * Created by anilpacaci on 2016-07-23.
 */
public class LdbcComplexQuery13Handler implements OperationHandler<LdbcQuery13, DbConnectionState> {
    @Override
    public void executeOperation(LdbcQuery13 ldbcQuery13, DbConnectionState dbConnectionState, ResultReporter resultReporter) throws DbException {
        Client client = ((GremlinDbConnectionState) dbConnectionState).getClient();
        Map<String, Object> params = new HashMap<>();
        params.put("person1_id", GremlinUtils.makeIid(Entity.PERSON, ldbcQuery13.person1Id()));
        params.put("person2_id", GremlinUtils.makeIid(Entity.PERSON, ldbcQuery13.person2Id()));
        params.put("person_label", Entity.PERSON.getName());

        if(ldbcQuery13.person1Id() == ldbcQuery13.person2Id()) {
            // same person, return 0
            resultReporter.report(1, new LdbcQuery13Result(0), ldbcQuery13);
            return;
        }

        // In only goes to depth 10
        String statement = "g.V().has(person_label, 'iid', person1_id)" +
                ".repeat(out('knows').simplePath()).until(has(person_label, 'iid', person2_id).or().loops().is(4))" +
                ".limit(1).path().count(local)";

        // TODO: is it possible to have no path between source & target. What is the length then?
        List<Result> results = null;
        try {
            results = client.submit(statement, params).all().get();
        } catch (InterruptedException | ExecutionException e) {
            throw new DbException("Remote execution failed", e);
        }

        if(results == null || results.isEmpty()) {
            // no path exists between two
            resultReporter.report(1, new LdbcQuery13Result(-1), ldbcQuery13);
            return;
        }

        int pathLength = results.get(0).getInt();
        // path includes both source and target vertices
        resultReporter.report(1, new LdbcQuery13Result(pathLength - 1), ldbcQuery13);
    }
}
