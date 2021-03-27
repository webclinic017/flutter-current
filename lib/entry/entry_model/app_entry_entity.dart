import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../member/member_model/entry_member_model/entry_member.dart';
import '../../member/member_model/entry_member_model/entry_member_entity.dart';
import '../../utils/db_consts.dart';

@immutable
class MyEntryEntity extends Equatable {


  const MyEntryEntity(
      {this.id,
      this.logId,
      this.currency,
      this.category = NO_CATEGORY,
      this.subcategory = NO_SUBCATEGORY,
      this.amount = 0,
      this.comment,
      this.dateTime,
      this.tagIDs = const {},
      this.entryMembers = const {},
      this.memberList}); //TODO get rid of members list eventually? do i need it if I have entryMembers list?

  final String id;
  final String logId;
  final String currency;
  final String category;
  final String subcategory;
  final int amount;
  final String comment;
  final DateTime dateTime;
  final Map<String, String> tagIDs;
  final Map<String, EntryMember> entryMembers;
  final List<String> memberList;

  @override
  List<Object> get props => [
        id,
        logId,
        currency,
        category,
        subcategory,
        amount,
        comment,
        dateTime,
        tagIDs,
        entryMembers,
        memberList,
      ];

  @override
  String toString() {
    return 'EntryEntity {$ID: $id, $LOG_ID: $logId, '
        'currency: $currency, $CATEGORY: $category, '
        '$SUBCATEGORY: $subcategory, $AMOUNT: $amount, $COMMENT: $comment'
        '$DATE_TIME: $dateTime, tagIDs: $tagIDs, members: $entryMembers, memberList: $memberList)}';
  }

  static MyEntryEntity fromSnapshot(DocumentSnapshot snap) {
    return MyEntryEntity(
      id: snap.id,
      logId: snap.data()[LOG_ID],
      currency: snap.data()[CURRENCY_NAME],
      category: snap.data()[CATEGORY],
      subcategory: snap.data()[SUBCATEGORY],
      amount: snap.data()[AMOUNT],
      comment: snap.data()[COMMENT],
      dateTime: DateTime.fromMillisecondsSinceEpoch(snap.data()[DATE_TIME]),
      tagIDs: (snap.data()[TAGS] as Map<String, dynamic>)
          ?.map((key, value) => MapEntry(key, value)),
      entryMembers: (snap.data()[MEMBERS] as Map<String, dynamic>)?.map(
          (key, value) => MapEntry(
              key, EntryMember.fromEntity(EntryMemberEntity.fromJson(value)))),
    );
  }

  Map<String, Object> toDocument() {
    return {
      LOG_ID: logId,
      CURRENCY_NAME: currency,
      CATEGORY: category,
      SUBCATEGORY: subcategory,
      AMOUNT: amount,
      COMMENT: comment,
      DATE_TIME: dateTime.millisecondsSinceEpoch,
      TAGS: tagIDs.map((key, value) => MapEntry(key, value)),
      MEMBERS: entryMembers
          .map((key, value) => MapEntry(key, value.toEntity().toJson())),
      MEMBER_LIST: memberList
    };
  }
}
