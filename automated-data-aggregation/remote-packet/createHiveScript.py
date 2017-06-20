import encodings
remove=[\
('-', ['']), \
(':', ['']), \
(';', ['']), \
('.', ['']), \
('/', ['']), \
('(', ['']), \
(')', ['']), \
('\\',['']), \
(',', ['']), \
('%', ['percent']),\
('#', ['num'])]


def getHiveTypes(num):
    with open('types.csv', 'r+') as f:
        f = unicode(f, errors='replace')
        content = f.readlines()
        hiveScript = [x.strip() for x in content] 
        return hiveScript.split(',')

def prepData(database, user):
    hiveScript = open('load-data.hql', 'a+')
    with open('data-sources.csv', 'r+') as sources:
        for source in sources:
            source.strip('\n')
            index,file,url,delimiter=source.split(",")
            filename=file.split(".")[0]
            header=""
            with open("raw-data/" + file, 'r+') as rawData:
                rawData = unicode(rawData, errors='replace')
                content = rawData.readlines()
                header = [x.strip() for x in content] 
            
            headers=header.split(delimiter)
            tableString="CREATE EXTERNAL TABLE IF NOT EXISTS " + database + "." + filename + " ( "
            types = getHiveTypes(index)
            for i in range(len(headers)):
                headers[i] = headers[i].strip('\n')
                for (char,replacement) in remove:
                    headers[i] = replace(headers[i], replacement)
                if i == len(headers) - 1:
                    tableString = tableString + headers[i] + types[i] + ") "
                else:
                    tableString = tableString + headers[i] + types[i] + ","
            tableString = tableString + "ROW FORMAT DELIMITED FIELDS TERMINATED BY \'\\t\' LINES TERMINATED BY \'\\n\' STORED AS TEXTFILE LOCATION '/user/" + user + "/" + database + \
            "/data/raw-zone/hive-ready-raw-data/" + filename + "\';"
            loadString = "LOAD DATA INPATH \'hdfs:/user/" + user + "/" + database + "/data/raw-zone/hive-ready-raw-data/" + filename + "-stripped.csv\' INTO TABLE " + database + "." + filename + ";"
            print(tablestring)
            print(loadString)
    hiveScript.close()