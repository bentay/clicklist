#!/bin/bash

#V='-v'
V=''
COOKIES=cookies

# Make initial request
curl $V -c $COOKIES 'https://www.kroger.com/onlineshopping/signin'

# Log in
DATA='{"account":{"email":"EMAIL_HERE","password":"PASSWORD_HERE","rememberMe":null},"location":""}'
curl $V -b $COOKIES -c $COOKIES -d ${DATA} -H 'Content-Type: application/json;charset=utf-8' 'https://www.kroger.com/user/authenticate'

# Access store base first.  Need to follow 302s (-L)
# Don't bother saving copious output
STORENAME='STORE-NAME'
AFTERLOGIN="https://www.kroger.com/storecatalog/servlet/en/${STORENAME}"
curl $V -L -b $COOKIES -c $COOKIES ${AFTERLOGIN} > /dev/null

# now add something?
# 2% milk == productId 72981
# whole milk == productId 72970
ITEM='catEntryId_1=72981'
QUANTITY='quantity_1=1'
STOREID='storeId=STOREID'
CATALOG='catalogId=CATALOGID'
ADDURL='https://www.kroger.com/storecatalog/servlet/AjaxOrderItemAdd'
DATA='langId=-1&calculationUsage=-2%2C-7&inventoryValidation=true&calculateOrder=1&orderId=.&doInventory=N&doPrice=N'

curl $V -b $COOKIES -c $COOKIES -H 'X-Requested-With: XMLHttpRequest' -H "Referer: ${AFTERLOGIN}" -d ${DATA} -d ${ITEM} -d ${QUANTITY} -d ${STOREID} -d ${CATALOG} ${ADDURL}
