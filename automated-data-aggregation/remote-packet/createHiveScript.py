import encodings
import io
import chardet
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
('%', ['percent']),\
('#', ['num']), \
(' ', [''])]


def getHiveTypes(num):
    with open('types.csv', 'r+') as f:
        if f.startswith(codecs.BOM_UTF8):
            encoding = 'utf-8-sig'
        else:
            result = chardet.detect(f)
            encoding = result['encoding']
        infile = io.open('types.csv', 'r', encoding=encoding)
        content = infile.readlines()
        infile.close()
        hiveScript = [x.strip() for x in content] 
        return hiveScript.split(',')

def prepData(database, user):
    hiveScript = open('load-data.hql', 'a+')
    with open('data-sources.csv', 'r+') as raw:
        if raw.startswith(codecs.BOM_UTF8):
            encoding = 'utf-8-sig'
        else:
            result = chardet.detect(raw)
            encoding = result['encoding']
        infile = io.open('data-sources.csv', 'r', encoding=encoding)
        sources = infile.readlines()
        infile.close()
        for source in sources:
            source.strip('\n')
            index,file,url,delimiter,header_row=source.split(",")
            filename=file.split(".")[0]
            header=""

            #open file to be modified
            raw_file = open("raw-data/" + file, 'r+')
            if raw_file.startswith(codecs.BOM_UTF8):
                encoding = 'utf-8-sig'
            else:
                result = chardet.detect(raw_file)
                encoding = result['encoding']
            infile = io.open('data-sources.csv', 'r', encoding=encoding)
            sources = infile.readlines()
            infile.close()
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