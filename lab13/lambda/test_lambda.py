#
# Title:test_lambda.py
# Description: demonstrate lambda/postgres
# Development Environment:OS X 10.13.6/Python 3.8.2
# Lambda Environment: Python 3.8 runtime
#
import json
import psycopg2

def lambda_handler(event, context):
    print("hello from lambda")
    print(event)

    dbhost = 'lab-db.coehbyjf9wsp.us-west-2.rds.amazonaws.com'
    dbname = 'lab13'
    dbpass = 'bigsekret'
    dbuser = 'usertest'

    sql = f"select * from test1"

    connect_arg = f"dbname='{dbname}' user='{dbuser}' password='{dbpass}' host='{dbhost}'"
    print(connect_arg)

    connection = psycopg2.connect(connect_arg)
    print(connection)

    cursor = connection.cursor()
    cursor.execute(sql)

    result = cursor.fetchall()
    print(result)

    cursor.close()
    connection.close()

    return {
        'statusCode': 200,
        'body': json.dumps('goodbye from lambda')
    }

if __name__ == "__main__":
    print('main noted')

#    logger = logging.getLogger()
#    logger.setLevel(Personality.get_logging_level())

# ;;; Local Variables: ***
# ;;; mode:python ***
# ;;; End: *** 
