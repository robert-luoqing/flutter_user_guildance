import 'user_guildance_anchor_inherit.dart';

class UserGuildanceModel {
  List<UserGuildanceItemModel> stack = [];
  UserGuildanceItemModel? current;

  /// Only currrent page equal anchorPageConditions, the group will be show up
  String currentPage = "";
}

class UserGuildanceItemModel {
  UserGuildanceItemModel({
    required this.visibleWithCondition,
    required this.data,
  });

  bool visibleWithCondition;
  AnchorData data;
}
