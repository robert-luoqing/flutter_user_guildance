import 'user_guildance_anchor_inherit.dart';

class UserGuildanceModel {
  UserGuildanceModel({
    required this.visible,
    required this.visibleWithCondition,
    this.data,
    this.currentPage,
  });

  bool visible;
  bool visibleWithCondition;

  AnchorData? data;

  /// Only currrent page equal anchorPageConditions, the group will be show up
  String? currentPage;
}
