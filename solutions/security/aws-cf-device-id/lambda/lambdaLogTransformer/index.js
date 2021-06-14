'use strict'
exports.handler = (event, context, callback) => {
    //console.log(event)
    /* Process the list of records and drop those containing Default_Action */
    const output = event.records.map((record) => {
        
        const entry = (Buffer.from(record.data, 'base64')).toString('utf8');
        var jsonEntry = JSON.parse(entry);
        //console.log(jsonEntry.httpRequest.headers)
        const headers = jsonEntry.httpRequest.headers;
        
        const args = jsonEntry.httpRequest.args;
        if ((typeof args !== 'undefined')){
            //console.log(xff.split(',')[0]);
            jsonEntry["httpRequest"]["username"] = args.split('=')[1];
        }

        let xff;
        for (let i =0; i < headers.length; i++) {
            const item = headers[i];
            if (item.name.toLowerCase() == 'x-forwarded-for') {
            xff = item.value;
            //console.log('got xff')
            break;
            }
        }
        if ((typeof xff !== 'undefined')){
            //console.log(xff.split(',')[0]);
            jsonEntry["httpRequest"]["clientIp"] = xff.split(',')[0];
        }

        let userAgent;
        for (let i =0; i < headers.length; i++) {
            const item = headers[i];
            if (item.name.toLowerCase() == 'user-agent') {
            userAgent = item.value;
            //console.log('got ua')
            break;
            }
        }
        if ((typeof userAgent !== 'undefined')){
            //console.log(userAgent.split(',')[0]);
            jsonEntry["httpRequest"]["userAgent"] = userAgent;
        }

        let cookie;
        for (let i =0; i < headers.length; i++) {
            const item = headers[i];
            if (item.name == 'cookie') {
            cookie = item.value;
            break;
            }
        }
        // if cookie existed in the request 
        if ((typeof cookie !== 'undefined')){
        const cookieArray = cookie.split(';');
        
        //console.log(cookieArray)
        for (let j=0; j < cookieArray.length; j++) {
            const item = cookieArray[j].trim();
            if (item.indexOf('_imp_apg_r_') == 0) {
                const name = item.split('=')[0];
                const value = item.split('=')[1];
                try {
                    var deviceId = JSON.parse(decodeURIComponent(value));
                    //console.log(decodeURIComponent(value))
                  } catch (e) { // catches a malformed cookie
                    console.error(e);
                  }
                jsonEntry["deviceidA"] = deviceId.diA;
                jsonEntry["deviceidB"] = deviceId.diB;
            }
            //console.log(jsonEntry);
        }

        //console.log(jsonEntry)
        }
        let objJsonStr = JSON.stringify(jsonEntry);
        let objJsonB64 = Buffer.from(objJsonStr).toString("base64"); 
        return {
            recordId: record.recordId,
            result: 'Ok',
            data: objJsonB64,
        };        
    }    );

    console.log(`Processing completed.  Successful records ${output.length}.`);
    callback(null, { records: output });
};
