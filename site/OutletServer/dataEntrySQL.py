import sqlite3
import pandas as pd

class Database :
	
	db = None
	cursor = None

	def __init__(self) :
		# db = sqlite3.connect(':memory:')
		# Creates or opens a file called mydb with a SQLite3 DB
		self.db = sqlite3.connect('healthDB')
		self.db.execute('pragma foreign_keys=ON;')

		self.cursor = self.db.cursor()

	def __del__(self):
		self.closeDatabase()

	def closeDatabase(self) :
		if self.db != None :
			try :
				self.db.commit()
				self.db.close()
			except sqlite3.ProgrammingError :
				print "failed to close or never opened"

	def commit(self) :
		self.db.commit()



def getRole(roleID, db = None) :

	if db == None :
		db = Database()

	db.cursor.execute('''SELECT * FROM ROLES WHERE ID=? LIMIT 1;''', (roleID,))
	row = db.cursor.fetchone()
	return row[1]

def getSurgery(surgeryID, db = None) :
	if db == None :
		db = Database()

	db.cursor.execute('''SELECT * FROM SURGERIES WHERE ID=? LIMIT 1;''', (surgeryID,))
	row = db.cursor.fetchone()
	return row

def getSurgeries(db = None) :
	
	if db == None :
		db = Database()
	db.cursor.execute('''SELECT * FROM SURGERIES;''')
	rows = []
	print "rows of surgeries: "
	for row in db.cursor :
		print row
		rows.append(row)
	return rows



def getStages(surgeryID, db = None) :
	
	if db == None :
		db = Database()
	db.cursor.execute('''SELECT * FROM STAGES WHERE SURGERY_ID=?;''', (surgeryID, ))
	rows = []
	print "rows of stages: " + str(surgeryID)
	for row in db.cursor :
		print row
		rows.append(row)
	return rows





def getSteps(stageID, db = None) :
	
	if db == None :
		db = Database()
	db.cursor.execute('''SELECT * FROM STEPS WHERE STAGE_ID=?;''', (stageID, ))
	rows = []
	print "rows of steps: " + str(stageID)
	for row in db.cursor :
		print row
		rows.append(row)
	return rows




def sqlTest() :


	# Create table
	# cursor = db.cursor()
	# cursor.execute('''
	# 	CREATE TABLE users(DEVICE_NUM INTEGER PRIMARY KEY, OUTLET_NUM INTEGER,
	# 	STATE INTEGER, BRIGHTNESS TEXT, MAC TEXT, IP TEXT, NAME TEXT)
	# 	''')
	# db.commit()
	db = Database()

	db.cursor.execute('''
		CREATE TABLE ROLES(ID INTEGER PRIMARY KEY, ROLE TEXT);''')


	db.cursor.execute('''
		CREATE TABLE SURGERIES(ID INTEGER PRIMARY KEY, SURGERY TEXT);''')


	db.cursor.execute('''
		CREATE TABLE STAGES(ID INTEGER PRIMARY KEY, SURGERY_ID INTEGER, 
		STAGE_NAME TEXT, STAGE_NUM INTEGER, 
		FOREIGN KEY(SURGERY_ID) REFERENCES SURGERIES(ID));''')


	db.cursor.execute('''
		CREATE TABLE STEPS(ID INTEGER PRIMARY KEY, 
		SURGERY_ID INTEGER, STAGE_ID INTEGER, ROLE_ID INTEGER,
		STEP_TEXT TEXT, STEP_NUM INTEGER, 
		FOREIGN KEY(SURGERY_ID) REFERENCES SURGERIES(ID),
		FOREIGN KEY(STAGE_ID) REFERENCES STAGES(ID),
		FOREIGN KEY(ROLE_ID) REFERENCES ROLES(ID));
		''')


	# Roles
	db.cursor.execute('''INSERT INTO ROLES(ID, ROLE)
                   VALUES(?, ?);''', (1, "Surgeon"))
	db.cursor.execute('''INSERT INTO ROLES(ID, ROLE)
                   VALUES(?, ?);''', (2, "Anesthesia"))
	db.cursor.execute('''INSERT INTO ROLES(ID, ROLE)
                   VALUES(?, ?);''', (3, "Nurse"))


	# Surgeries
	db.cursor.execute('''INSERT INTO SURGERIES(ID, SURGERY)
                   VALUES(?, ?);''', (1, "Heart Transplant"))
	db.cursor.execute('''INSERT INTO SURGERIES(ID, SURGERY)
                   VALUES(?, ?);''', (2, "Bypass"))


	# Stages
	# Heart transplant

	db.cursor.execute('''INSERT INTO STAGES(ID, SURGERY_ID, STAGE_NAME, STAGE_NUM)
                   VALUES(?, ?, ?, ?);''', (1, 1, "Check all the things", 1))
	db.cursor.execute('''INSERT INTO STAGES(ID, SURGERY_ID, STAGE_NAME, STAGE_NUM)
                   VALUES(?, ?, ?, ?);''', (2, 1, "Open the things", 2))
	db.cursor.execute('''INSERT INTO STAGES(ID, SURGERY_ID, STAGE_NAME, STAGE_NUM)
                   VALUES(?, ?, ?, ?);''', (3, 1, "Close the things", 3))

	# Bypass
	db.cursor.execute('''INSERT INTO STAGES(ID, SURGERY_ID, STAGE_NAME, STAGE_NUM)
                   VALUES(?, ?, ?, ?);''', (4, 2, "Check bypass things", 1))
	db.cursor.execute('''INSERT INTO STAGES(ID, SURGERY_ID, STAGE_NAME, STAGE_NUM)
                   VALUES(?, ?, ?, ?);''', (5, 2, "take out heart, insert machine", 2))
	db.cursor.execute('''INSERT INTO STAGES(ID, SURGERY_ID, STAGE_NAME, STAGE_NUM)
                   VALUES(?, ?, ?, ?);''', (6, 2, "Weld back together", 3))


	# Steps

	# heart transplant
	# stage 1
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (1, 1, 1, 1, "surgeon step 1 stage 1", 1))
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (2, 1, 1, 2, "anesthesia step 2 stage 1", 2))

	# stage 2
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (3, 1, 2, 1, "surgeon step 1 stage 2", 1))
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (4, 1, 2, 3, "nurse step 2 stage 2", 2))

	# stage 3
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (5, 1, 3, 2, "anesthesia step 1 stage 3", 1))
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (6, 1, 3, 3, "nurse step 2 stage 3", 2))





	# bypass
	# stage 1
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (8, 2, 4, 1, "b surgeon step 1 stage 1", 1))
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (9, 2, 4, 2, "b anesthesia step 2 stage 1", 2))

	# stage 2
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (10, 2, 5, 1, "b surgeon step 1 stage 2", 1))
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (11, 2, 5, 3, "b nurse step 2 stage 2", 2))

	# stage 3
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (12, 2, 6, 2, "b anesthesia step 1 stage 3", 1))
	db.cursor.execute('''INSERT INTO STEPS(ID, SURGERY_ID, STAGE_ID, ROLE_ID, STEP_TEXT, STEP_NUM)
                   VALUES(?, ?, ?, ?, ?, ?);''', (13, 2, 6, 3, "b nurse step 2 stage 3", 2))


	print pd.read_sql_query("SELECT * FROM ROLES", db.db)
	print pd.read_sql_query("SELECT * FROM SURGERIES", db.db)
	print pd.read_sql_query("SELECT * FROM STAGES", db.db)
	print pd.read_sql_query("SELECT * FROM STEPS", db.db)

	db.commit()


	return "hello to the worl"




def insertStep() :
	None


def insertStage() :
	None


def insertRole() :
	None



def insertSurgery() :
	None



def buildDatabase() :
	None



# sqlTest()