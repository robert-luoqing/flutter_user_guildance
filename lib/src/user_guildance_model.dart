import 'user_guildance_anchor_inherit.dart';

class UserGuildanceModel {
  const UserGuildanceModel._([
    this.visible = false,
    this.data,
  ]);

  const UserGuildanceModel.initial() : this._();

  const UserGuildanceModel.custom({
    required bool visible,
    AnchorData? anchorData,
  }) : this._(visible, anchorData);

  final bool visible;
  final AnchorData? data;
}
