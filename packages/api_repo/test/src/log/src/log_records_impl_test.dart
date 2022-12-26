final user = {
  "allowedRoles": ["International Traveller", "Producer", "Employee", "Visitor"],
  "status": "Active",
  "firstName": "Eliza",
  "lastName": "Davidson",
  "countryOfResidency": "Australia",
  "email": "davo.ajd@gmail.com",
  "phoneNumber": "418800700",
  "id": 24,
  "countryCode": "+61",
  "role": "Employee",
  "pic": "QDZZ3333",
  "propertyName": "BIG RIVER",
  "state": "QLD",
  "street": "888 BACK ROAD ",
  "town": "BRISBANE ",
  "postcode": 4000,
  "signature": null,
  "logOn": null,
  "employeeNumber": "E20",
  "driversLicense": "207534",
  "ddt": null,
  "persons": null,
  "contactDetails": null,
  "reasonForVisit": null,
  "serviceRole": null,
  "ohsRequirements": null,
  "questionnaire": null,
  "region": null,
  "company": "MINE",
  "picVisiting": null,
  "reason": null,
  "worksafeQuestionsForm": null,
  "countryOfOrigin": null,
  "countryVisiting": null,
  "entryDate": null,
  "exitDate": null,
  "passport": null,
  "registrationToken":
      "c4RM6G2GS2S9b2HldbDf2L:APA91bFu-C3V_isJou9KOsiZnpP5Z4OCMEgrkQNWSVW_IQXs8KZi5DsBoTr3fh04KVC_3pLNQILYbDzJS8rl5YV0FDVwdQzUmjmjOfgQOEjspc9TSEypnpfrnyeazgX476C423cF6n-2",
  "createdAt": "2022-10-08T01:41:12.285",
  "updatedAt": "2022-12-24T21:54:06.474",
  "ngr": "NGR2022",
  "lpaUsername": "QDZZ3333-2305875",
  "lpaPassword": "Q6qN2VquqqtpkBP!",
  "nlisUsername": "",
  "nlisPassword": "",
  "msaNumber": "",
  "nfasAccreditationNumber": "",
  "businessName": null,
  "sector": null,
  "contactName": null,
  "eventName": null,
  "contactEmail": null,
  "contactNumber": null,
  "startDate": null,
  "endDate": null,
  "edec": null
};

final onlineRecords = {
  "status": "success",
  "data": [
    {
      "isOffline": false,
      "id": 2157,
      "enterDate": "2022-12-24T15:11:37.792Z",
      "exitDate": null,
      "createdAt": "2022-12-24T15:11:37.792Z",
      "updatedAt": "2022-12-24T16:21:51.537Z",
      "isPeopleTravelingWith": null,
      "userTravelingAlong": [],
      "isQfeverVaccinated": false,
      "isFluSymptoms": false,
      "isOverSeaVisit": false,
      "isAllMeasureTaken": false,
      "isOwnerNotified": false,
      "rego": null,
      "riskRating": null,
      "expectedDepartureTime": null,
      "expectedDepartureDate": null,
      "signature": null,
      "warakirriFarm": null,
      "hasBeenInducted": null,
      "isConfinedSpace": null,
      "additionalInfo": null,
      "user": user,
      "geofence": geofence
    }
  ]
};

Map<String, Object?> get geofence {
  return {
    "id": 94,
    "name": "Playground ",
    "color": "ffdb3325",
    "points": {"type": "Polygon", "coordinates": []},
    "center": {
      "type": "Point",
      "coordinates": [0, 0]
    },
    "pic": "3ABCD123",
    "createdAt": "2022-10-12T01:54:38.880Z",
    "updatedAt": "2022-10-12T01:54:38.880Z",
    "companyOwner": null
  };
}

final onlineRecordsWithForm = {
  "status": null,
  "data": [
    {
      "isOffline": false,
      "id": 2157,
      "enterDate": "2022-12-24T15:11:37.792Z",
      "exitDate": null,
      "createdAt": "2022-12-24T15:11:37.792Z",
      "updatedAt": "2022-12-24T16:21:51.537Z",
      "isPeopleTravelingWith": true,
      "userTravelingAlong": ["Andrew Davidson"],
      "isQfeverVaccinated": true,
      "isFluSymptoms": false,
      "isOverSeaVisit": false,
      "isAllMeasureTaken": false,
      "isOwnerNotified": false,
      "rego": "234TEST",
      "riskRating": "LOW",
      "expectedDepartureTime": null,
      "expectedDepartureDate": "2022-12-24T20:47:08.757067",
      "signature":
          "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAARzQklUCAgICHwIZIgAAABrSURBVBiVrVCxDcRACPNF2eBKKvZgCSZlKjpuBqfJ81dFeendWbYM9iBJvMDxxgQA507WWogIAIC7Y875FXmjqmhmVFWqKs2MVfWR2acjApnZAZnZ6T/92EZ3h4i0ICJw9+Zjn+epzPj7jhffLkGmczztoQAAAABJRU5ErkJggg==",
      "warakirriFarm": null,
      "hasBeenInducted": null,
      "isConfinedSpace": null,
      "additionalInfo": null,
      "user": user,
      "geofence": geofence,
    }
  ]
};
