import encodings
import codecs

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
("\'", ['']), \
('\"', ['']), \
('%', ['percent']),\
('#', ['num']), \
('ï»¿', ['']), \
(' ', ['_']), \
('\s\s\s', ['_']), \
('\s\s', ['_']), \
('\s', ['_'])]

def getHiveTypes(num):
    with open('types.csv', 'rt+') as f:
        content = f.readlines()
        all_data = [x.strip() for x in content]
        data = all_data[num]
        return data.split(',')

def prepData(database, user):
    hiveScript = open('load-data.hql', 'a+')
    with open('data-sources.csv', 'rt+') as raw:
        sources = raw.readlines()
        for source_index in range(1, len(sources)):
            source = sources[source_index]
            source.strip('\n')
            index,file,url,delimiter,header_row = source.split(",")
            print("Preparing HQL script for " + file)
            filename=file.split(".")[0]
            header=""

            #open file to be modified
            src = "raw-data/" + file
            f = open(src, encoding="latin-1")
            content = f.readlines()

            #strip header
            header = content[int(header_row)].strip()
            if delimiter == 'c' or delimiter == 'comma':
                delimiter = ','
            delimiter = delimiter.strip()
            headers = header.split(delimiter)
            f.close()

            #write HQL Script
            tableString = "CREATE EXTERNAL TABLE IF NOT EXISTS " + database + "." + filename + " ( "
            types = getHiveTypes(int(index))

            print("headers: " + str(len(headers)))
            print("types: " + str(len(types)))

            #prep headers and write to HQL script
            for i in range(len(headers)):
                headers[i] = headers[i].strip('\n')
                headers[i] = headers[i].strip()
                for (char,replacement) in remove:
                    headers[i] = headers[i].replace(char, replacement[0])
                if i == len(headers) - 1:
                    tableString = tableString + headers[i] + " " + types[i] + ") "
                else:
                    tableString = tableString + headers[i] + " " + types[i] + ","
            tableString = tableString + "ROW FORMAT DELIMITED FIELDS TERMINATED BY \'" + delimiter + "\' LINES TERMINATED BY \'\\n\' STORED AS TEXTFILE LOCATION '/user/" + user + "/" + database + \
            "/data/raw-zone/prepped-raw-data/" + filename + "\';"
            loadString = "LOAD DATA INPATH \'hdfs:/user/" + user + "/" + database + "/data/raw-zone/prepped-raw-data/" + filename + "-stripped.csv\' INTO TABLE " + database + "." + filename + ";"
            print(file + " succesfully prepared! \n")
            hiveScript.write(tableString)
            hiveScript.write(loadString)
    hiveScript.close()