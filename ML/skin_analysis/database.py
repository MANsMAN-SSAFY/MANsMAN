from sqlalchemy import *
from sqlalchemy.orm import sessionmaker

DB_URL = 'mysql+pymysql://ssafy:ssafy123$@localhost:3306/testdb'

class engineconn:

    def __init__(self):
        self.engine = create_engine(DB_URL, pool_recycle = 500)

    def sessionmaker(self):
        Session = sessionmaker(bind=self.engine)
        session = Session()
        return session

    def connection(self):
        conn = self.engine.connect()
        return conn