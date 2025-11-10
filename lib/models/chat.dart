class Conversation {
  final int userId;
  final String username;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  Conversation({
    required this.userId,
    required this.username,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['user_id'] as int,
      username: json['username'] as String,
      lastMessage: json['last_message'] as String,
      lastMessageAt: DateTime.parse(json['last_message_at'] as String),
      unreadCount: json['unread_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt.toIso8601String(),
      'unread_count': unreadCount,
    };
  }

  bool get hasUnreadMessages => unreadCount > 0;
}

class ChatMessage {
  final int id;
  final int senderId;
  final int storeId;
  final String content;
  final String messageType;
  final bool isFromCustomer;
  final String status;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime? readAt;
  final bool isDeleted;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.storeId,
    required this.content,
    required this.messageType,
    required this.isFromCustomer,
    required this.status,
    this.attachmentUrl,
    required this.createdAt,
    this.readAt,
    required this.isDeleted,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      senderId: json['sender_id'] as int,
      storeId: json['store_id'] as int,
      content: json['content'] as String,
      messageType: json['message_type'] as String,
      isFromCustomer: json['is_from_customer'] as bool,
      status: json['status'] as String,
      attachmentUrl: json['attachment_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'store_id': storeId,
      'content': content,
      'message_type': messageType,
      'is_from_customer': isFromCustomer,
      'status': status,
      'attachment_url': attachmentUrl,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }

  // Helper getters
  bool get isRead => readAt != null;
  bool get hasAttachment => attachmentUrl != null && attachmentUrl!.isNotEmpty;
  
  MessageStatus get messageStatus {
    switch (status.toLowerCase()) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }

  AttachmentType? get attachmentType {
    if (messageType == 'image') return AttachmentType.image;
    if (messageType == 'video') return AttachmentType.video;
    if (messageType == 'document') return AttachmentType.document;
    if (messageType == 'location') return AttachmentType.location;
    return null;
  }
}

class SendMessageRequest {
  final int storeId;
  final String content;
  final String messageType;
  final bool isFromCustomer;
  final String? attachmentUrl;

  SendMessageRequest({
    required this.storeId,
    required this.content,
    this.messageType = 'text',
    this.isFromCustomer = false,
    this.attachmentUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'content': content,
      'message_type': messageType,
      'is_from_customer': isFromCustomer,
      'attachment_url': attachmentUrl,
    };
  }
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

enum AttachmentType {
  image,
  video,
  document,
  location,
}

