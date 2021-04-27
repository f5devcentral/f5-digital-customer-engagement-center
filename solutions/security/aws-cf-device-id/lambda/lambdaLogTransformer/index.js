'use strict'
exports.handler = (event, context, callback) => {
    /* Process the list of records and drop those containing Default_Action */
    const output = event.records.map((record) => {
        
        const entry = (Buffer.from(record.data, 'base64')).toString('utf8');
        if (!entry.match(/Default_Action/g))
        {
            return {
              
                recordId: record.recordId,
                result: 'Ok',
                data: record.data,
            };
        }
        else {
            return {
                recordId: record.recordId,
                result: 'Dropped',
                data: record.data,
            };
        }
    });
  
    console.log(`Processing completed.  Successful records ${output.length}.`);
    callback(null, { records: output });
};