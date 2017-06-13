def getHiveTypes(num=-1):
    result="( "
    fileChoice=""
    if num == -1:
        print("Which File's column type mapping would you like to generate?\n1.buildbps\n2.Educator Evals\n3.Employee earnings\n4.Grads Attending College\n5.Graduates\n6.Public schools\n7.Private schools")
        fileChoice = input("Type the number of the file you want: ")
        fileChoice = fileChoice.lstrip()
    else:
        fileChoice = str(num)
    file = ""
    if fileChoice == '1':
        file = 'buildbps-types.csv'
    elif fileChoice=='2':
        file = 'EducatorEvalPerf-types.csv'
    elif fileChoice=='3':
        file = 'earnings-types.csv'
    elif fileChoice=='4':
        file = 'gradsCollege-types.csv'
    elif fileChoice=='5':
        file = 'graduates-types.csv'
    elif fileChoice=='6':
        file = 'public-types.csv'
    elif fileChoice=='7':
        file = 'non-public-types.csv'

    with open(file, 'r+') as f:
        hiveScript = f.read()
        types = hiveScript.split(",")
        count = 0
        for value in types:
            if count == len(types) - 1:
                result = result + "${params[" + str(count) + "]} " + value
            else:
                result = result + "${params[" + str(count) + "]} " + value + ", "
                count = count + 1
    result = result + " )"
    print(result)
