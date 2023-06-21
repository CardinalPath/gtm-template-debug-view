___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Enable Debug View",
  "description": "",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "cookie_name",
    "displayName": "Cookie Name",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "query_param",
    "displayName": "Query Parameter",
    "simpleValueType": true,
    "help": "?[query_param]\u003dtrue to enable debug mode"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const queryPermission = require('queryPermission');
const log = require('logToConsole');
const getParam = require('getQueryParameters');
const getUrl = require('getUrl');
const host=getUrl("host");
const getContainerVersion = require('getContainerVersion');
const setCookie = require('setCookie');
const getCookieValues = require('getCookieValues');

const cv = getContainerVersion();
data.debugMode=cv.debugMode;
data.environment=cv.environmentName;

function cookieOptions(action){
  var age=60*60*24*1;
  if(action=="delete"){ age=-1; } 
  const options={'domain': host,  'path': '/', 'max-age': age};
  return options;
}

const cp_debug= getUrl('query', false, null, 'cp_debug');

if (queryPermission('get_url', 'query', data.query_param)) {
  const query_param=getParam(data.query_param); // paramater used to trigger debug mode.
  let cookieValues;

  if(query_param=="true"||query_param=="1"){
    setCookie(data.cookie_name, 'true', cookieOptions("add"));
  }
  if(query_param=="false"||query_param=="0"){
    setCookie(data.cookie_name, 'true', cookieOptions("delete"));
  } 
  cookieValues = getCookieValues(data.cookie_name);
  if(cookieValues[0]=="true" || data.debugMode===true||data.debugMode==1||data.debugMode=="true"){
    return true;
  }
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 3/9/2023, 4:04:03 PM


