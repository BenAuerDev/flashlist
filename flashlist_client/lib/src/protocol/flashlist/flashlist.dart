/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class Flashlist extends _i1.SerializableEntity {
  Flashlist._({
    this.id,
    required this.uuid,
    required this.title,
    required this.color,
    this.items,
    this.authors,
  });

  factory Flashlist({
    int? id,
    required String uuid,
    required String title,
    required String color,
    List<_i2.FlashlistItem?>? items,
    List<_i2.AppUser?>? authors,
  }) = _FlashlistImpl;

  factory Flashlist.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Flashlist(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      uuid: serializationManager.deserialize<String>(jsonSerialization['uuid']),
      title:
          serializationManager.deserialize<String>(jsonSerialization['title']),
      color:
          serializationManager.deserialize<String>(jsonSerialization['color']),
      items: serializationManager
          .deserialize<List<_i2.FlashlistItem?>?>(jsonSerialization['items']),
      authors: serializationManager
          .deserialize<List<_i2.AppUser?>?>(jsonSerialization['authors']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String uuid;

  String title;

  String color;

  List<_i2.FlashlistItem?>? items;

  List<_i2.AppUser?>? authors;

  Flashlist copyWith({
    int? id,
    String? uuid,
    String? title,
    String? color,
    List<_i2.FlashlistItem?>? items,
    List<_i2.AppUser?>? authors,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuid': uuid,
      'title': title,
      'color': color,
      if (items != null)
        'items': items?.toJson(valueToJson: (v) => v?.toJson()),
      if (authors != null)
        'authors': authors?.toJson(valueToJson: (v) => v?.toJson()),
    };
  }
}

class _Undefined {}

class _FlashlistImpl extends Flashlist {
  _FlashlistImpl({
    int? id,
    required String uuid,
    required String title,
    required String color,
    List<_i2.FlashlistItem?>? items,
    List<_i2.AppUser?>? authors,
  }) : super._(
          id: id,
          uuid: uuid,
          title: title,
          color: color,
          items: items,
          authors: authors,
        );

  @override
  Flashlist copyWith({
    Object? id = _Undefined,
    String? uuid,
    String? title,
    String? color,
    Object? items = _Undefined,
    Object? authors = _Undefined,
  }) {
    return Flashlist(
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      color: color ?? this.color,
      items: items is List<_i2.FlashlistItem?>? ? items : this.items?.clone(),
      authors: authors is List<_i2.AppUser?>? ? authors : this.authors?.clone(),
    );
  }
}
