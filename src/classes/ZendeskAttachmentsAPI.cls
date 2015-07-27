// This class provides functionality to call the Zendesk Attachments API
public class ZendeskAttachmentsAPI extends ZendeskResourceBase {

	private class AttachmentWrapper {
		public ZAttachment attachment {get;set;}
	}

	public ZendeskAttachmentsAPI(ZendeskAPI zapi) {
		super(zapi);
	}

	public String uploadAttachment(String fileName, String fileContentType, Blob fileBody) {
		if (String.isBlank(fileName)) { throw new ZendeskException('fileName parameter must not be empty'); }
		if (String.isBlank(fileContentType)) { throw new ZendeskException('fileContentType parameter must not be empty'); }
		if (fileBody == null) { throw new ZendeskException('fileBody parameter must not be null'); }

		String zendeskAttachmentToken = null;
		try {
			HttpRequest req = zapi.createRequest('POST', '/uploads.json', new Map<String, Object>{'filename'=>urlEncode(fileName)});
			req.setHeader('Content-Type', fileContentType);
			req.setBodyAsBlob(fileBody);
			String resBody = zapi.sendRequest(req);

			// Extract the token from the response
			Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(resBody);
			if (jsonMap.containsKey('upload')) {
				Map<String, Object> upload = (Map<String, Object>)jsonMap.get('upload');
				zendeskAttachmentToken = (String)upload.get('token');
			}
			else {
				throw new ZendeskException('Unexpected content in response. Could not find "upload"');
			}
		}
		catch(Exception e) {
			throw new ZendeskException('Error uploading Attachment: ' + e.getMessage());
		}

		return zendeskAttachmentToken;
	}

	public void deleteAttachment(Long attachmentId) {
		if (attachmentId == null) { throw new ZendeskException('attachmentId parameter must not be null'); }

		zapi.sendRequest(zapi.createRequest('DELETE', '/attachments/'+attachmentId+'.json'));
	}

	public ZAttachment getAttachment(Long attachmentId) {
		if (attachmentId == null) { throw new ZendeskException('attachmentId parameter must not be null'); }

		HttpRequest req = zapi.createRequest('GET', '/attachments/'+attachmentId+'.json');
		AttachmentWrapper resultWrapper = (AttachmentWrapper)JSON.deserialize(zapi.sendRequest(req), AttachmentWrapper.class);
		return resultWrapper.attachment;
	}

	public void redactCommentAttachment(Long ticketId, Long commentId, Long attachmentId) {
		if (ticketId == null) { throw new ZendeskException('ticketId parameter must not be null'); }
		if (commentId == null) { throw new ZendeskException('commentId parameter must not be null'); }
		if (attachmentId == null) { throw new ZendeskException('attachmentId parameter must not be null'); }

		zapi.sendRequest(zapi.createRequest('PUT', '/tickets/'+ticketId+'/comments/'+commentId+'/attachments/'+attachmentId+'/redact.json', '{}'));
	}

}