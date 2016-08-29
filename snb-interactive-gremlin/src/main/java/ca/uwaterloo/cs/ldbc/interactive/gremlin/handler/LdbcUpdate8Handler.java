package ca.uwaterloo.cs.ldbc.interactive.gremlin.handler;

import ca.uwaterloo.cs.ldbc.interactive.gremlin.*;
import com.ldbc.driver.DbConnectionState;
import com.ldbc.driver.DbException;
import com.ldbc.driver.OperationHandler;
import com.ldbc.driver.ResultReporter;
import com.ldbc.driver.workloads.ldbc.snb.interactive.LdbcNoResult;
import com.ldbc.driver.workloads.ldbc.snb.interactive.LdbcUpdate8AddFriendship;

import java.util.HashMap;
import java.util.Map;

public class LdbcUpdate8Handler implements OperationHandler<LdbcUpdate8AddFriendship, DbConnectionState> {
    @Override
    public void executeOperation(LdbcUpdate8AddFriendship ldbcUpdate8AddFriendship, DbConnectionState dbConnectionState, ResultReporter resultReporter) throws DbException {
        UpdateHandler updateHandler = ((GremlinDbConnectionState) dbConnectionState).getUpdateHandler();
        Map<String, Object> params = new HashMap<>();
        params.put("p1_id", GremlinUtils.makeIid(Entity.PERSON, ldbcUpdate8AddFriendship.person1Id()));
        params.put("p2_id", GremlinUtils.makeIid(Entity.PERSON, ldbcUpdate8AddFriendship.person2Id()));
        params.put("person_label", Entity.PERSON.getName());
        params.put( "creation_date", String.valueOf( ldbcUpdate8AddFriendship.creationDate().getTime() ) );
        String statement = "p1 = g.V().has(person_label, 'iid', p1_id).next(); " +
                "p2 = g.V().has(person_label, 'iid', p2_id).next(); " +
                "p1.addEdge('knows', p2).property('creationDate', creation_date);" +
                "p2.addEdge('knows', p1).property('creationDate', creation_date);";
        updateHandler.submitQuery( statement, params );

        resultReporter.report(0, LdbcNoResult.INSTANCE, ldbcUpdate8AddFriendship);

    }
}