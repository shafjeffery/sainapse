const AWS = require('aws-sdk');

// Initialize S3
const s3 = new AWS.S3({
  region: 'ap-southeast-1' // Change to your region
});

exports.handler = async (event) => {
  try {
    console.log('Event:', JSON.stringify(event, null, 2));
    
    // Parse request body
    const body = JSON.parse(event.body);
    const { s3Key, contentType, userId } = body;
    
    if (!s3Key || !contentType || !userId) {
      return {
        statusCode: 400,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'POST, OPTIONS'
        },
        body: JSON.stringify({
          error: 'Missing required parameters: s3Key, contentType, userId'
        })
      };
    }
    
    // Generate presigned URL for S3 upload
    const params = {
      Bucket: 'sainapse-documents', // Your S3 bucket name
      Key: s3Key,
      Expires: 300, // URL valid for 5 minutes
      ContentType: contentType,
      ACL: 'private' // Make file private
    };
    
    console.log('Generating presigned URL for:', params);
    
    const uploadUrl = await s3.getSignedUrlPromise('putObject', params);
    
    console.log('Generated presigned URL successfully');
    
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'POST, OPTIONS'
      },
      body: JSON.stringify({
        uploadUrl: uploadUrl,
        s3Key: s3Key,
        expiresIn: 300
      })
    };
    
  } catch (error) {
    console.error('Error generating presigned URL:', error);
    
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'POST, OPTIONS'
      },
      body: JSON.stringify({
        error: 'Failed to generate presigned URL',
        details: error.message
      })
    };
  }
};
