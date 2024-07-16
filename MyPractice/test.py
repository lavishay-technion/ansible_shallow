users = [{"lastname": "Schapelle", "members": ["Alex", "Sharon"]},{"lastname": "Golan", "members": ["Yoni", "David"]}]

for item0 in users:
    for index,item1 in enumerate(item0['members']):
        print(f'{index} : {item1}')
      
