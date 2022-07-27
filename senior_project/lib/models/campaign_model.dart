import 'dart:convert';

class Campaign {
  String ownerId;
  String campaignUrl;
  String campaignId;
  String restaurantId;
  Campaign({
    this.ownerId,
    this.campaignUrl,
    this.campaignId,
    this.restaurantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'campaignUrl': campaignUrl,
      'campaignId': campaignId,
      'restaurantId': restaurantId,
    };
  }

  factory Campaign.fromMap(Map<String, dynamic> map) {
    return Campaign(
      ownerId: map['ownerId'],
      campaignUrl: map['campaignUrl'],
      campaignId: map['campaignId'],
      restaurantId: map['restaurantId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Campaign.fromJson(String source) =>
      Campaign.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Campaign(ownerId: $ownerId, campaignUrl: $campaignUrl, campaignId: $campaignId, restaurantId: $restaurantId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Campaign &&
        other.ownerId == ownerId &&
        other.campaignUrl == campaignUrl &&
        other.campaignId == campaignId &&
        other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    return ownerId.hashCode ^
        campaignUrl.hashCode ^
        campaignId.hashCode ^
        restaurantId.hashCode;
  }
}
