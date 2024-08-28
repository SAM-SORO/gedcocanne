// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decharger_cours.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDechargerCoursCollection on Isar {
  IsarCollection<DechargerCours> get dechargerCours => this.collection();
}

const DechargerCoursSchema = CollectionSchema(
  name: r'DechargerCours',
  id: -3183901566822394061,
  properties: {
    r'dateHeureDecharg': PropertySchema(
      id: 0,
      name: r'dateHeureDecharg',
      type: IsarType.dateTime,
    ),
    r'dateHeureP1': PropertySchema(
      id: 1,
      name: r'dateHeureP1',
      type: IsarType.dateTime,
    ),
    r'dateHeureP2': PropertySchema(
      id: 2,
      name: r'dateHeureP2',
      type: IsarType.dateTime,
    ),
    r'etatAffectation': PropertySchema(
      id: 3,
      name: r'etatAffectation',
      type: IsarType.bool,
    ),
    r'etatBroyage': PropertySchema(
      id: 4,
      name: r'etatBroyage',
      type: IsarType.bool,
    ),
    r'etatModification': PropertySchema(
      id: 5,
      name: r'etatModification',
      type: IsarType.bool,
    ),
    r'etatSynchronisation': PropertySchema(
      id: 6,
      name: r'etatSynchronisation',
      type: IsarType.bool,
    ),
    r'ligneId': PropertySchema(
      id: 7,
      name: r'ligneId',
      type: IsarType.long,
    ),
    r'matriculeAgent': PropertySchema(
      id: 8,
      name: r'matriculeAgent',
      type: IsarType.string,
    ),
    r'parcelle': PropertySchema(
      id: 9,
      name: r'parcelle',
      type: IsarType.string,
    ),
    r'poidsNet': PropertySchema(
      id: 10,
      name: r'poidsNet',
      type: IsarType.double,
    ),
    r'poidsP1': PropertySchema(
      id: 11,
      name: r'poidsP1',
      type: IsarType.double,
    ),
    r'poidsP2': PropertySchema(
      id: 12,
      name: r'poidsP2',
      type: IsarType.double,
    ),
    r'poidsTare': PropertySchema(
      id: 13,
      name: r'poidsTare',
      type: IsarType.double,
    ),
    r'techCoupe': PropertySchema(
      id: 14,
      name: r'techCoupe',
      type: IsarType.string,
    ),
    r'veCode': PropertySchema(
      id: 15,
      name: r'veCode',
      type: IsarType.string,
    )
  },
  estimateSize: _dechargerCoursEstimateSize,
  serialize: _dechargerCoursSerialize,
  deserialize: _dechargerCoursDeserialize,
  deserializeProp: _dechargerCoursDeserializeProp,
  idName: r'id',
  indexes: {
    r'veCode': IndexSchema(
      id: 5501520949139134785,
      name: r'veCode',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'veCode',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'poidsP1': IndexSchema(
      id: -2205479777744137196,
      name: r'poidsP1',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'poidsP1',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'poidsTare': IndexSchema(
      id: 7633280571401959752,
      name: r'poidsTare',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'poidsTare',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'poidsP2': IndexSchema(
      id: -3852656153184023898,
      name: r'poidsP2',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'poidsP2',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'dateHeureP1': IndexSchema(
      id: 5090339968361605756,
      name: r'dateHeureP1',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateHeureP1',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'dateHeureDecharg': IndexSchema(
      id: 6979104598661061251,
      name: r'dateHeureDecharg',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateHeureDecharg',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'dateHeureP2': IndexSchema(
      id: -4691606224825081063,
      name: r'dateHeureP2',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateHeureP2',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'techCoupe': IndexSchema(
      id: -3029946672024321022,
      name: r'techCoupe',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'techCoupe',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'matriculeAgent': IndexSchema(
      id: 500781277297875947,
      name: r'matriculeAgent',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'matriculeAgent',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'etatSynchronisation': IndexSchema(
      id: -5526552659358308900,
      name: r'etatSynchronisation',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'etatSynchronisation',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'etatModification': IndexSchema(
      id: -980340134437142290,
      name: r'etatModification',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'etatModification',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'ligneId': IndexSchema(
      id: 2339148975998993162,
      name: r'ligneId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ligneId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dechargerCoursGetId,
  getLinks: _dechargerCoursGetLinks,
  attach: _dechargerCoursAttach,
  version: '3.1.0+1',
);

int _dechargerCoursEstimateSize(
  DechargerCours object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.matriculeAgent.length * 3;
  bytesCount += 3 + object.parcelle.length * 3;
  bytesCount += 3 + object.techCoupe.length * 3;
  bytesCount += 3 + object.veCode.length * 3;
  return bytesCount;
}

void _dechargerCoursSerialize(
  DechargerCours object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateHeureDecharg);
  writer.writeDateTime(offsets[1], object.dateHeureP1);
  writer.writeDateTime(offsets[2], object.dateHeureP2);
  writer.writeBool(offsets[3], object.etatAffectation);
  writer.writeBool(offsets[4], object.etatBroyage);
  writer.writeBool(offsets[5], object.etatModification);
  writer.writeBool(offsets[6], object.etatSynchronisation);
  writer.writeLong(offsets[7], object.ligneId);
  writer.writeString(offsets[8], object.matriculeAgent);
  writer.writeString(offsets[9], object.parcelle);
  writer.writeDouble(offsets[10], object.poidsNet);
  writer.writeDouble(offsets[11], object.poidsP1);
  writer.writeDouble(offsets[12], object.poidsP2);
  writer.writeDouble(offsets[13], object.poidsTare);
  writer.writeString(offsets[14], object.techCoupe);
  writer.writeString(offsets[15], object.veCode);
}

DechargerCours _dechargerCoursDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DechargerCours();
  object.dateHeureDecharg = reader.readDateTime(offsets[0]);
  object.dateHeureP1 = reader.readDateTime(offsets[1]);
  object.dateHeureP2 = reader.readDateTimeOrNull(offsets[2]);
  object.etatAffectation = reader.readBool(offsets[3]);
  object.etatBroyage = reader.readBool(offsets[4]);
  object.etatModification = reader.readBool(offsets[5]);
  object.etatSynchronisation = reader.readBool(offsets[6]);
  object.id = id;
  object.ligneId = reader.readLong(offsets[7]);
  object.matriculeAgent = reader.readString(offsets[8]);
  object.parcelle = reader.readString(offsets[9]);
  object.poidsP1 = reader.readDouble(offsets[11]);
  object.poidsP2 = reader.readDoubleOrNull(offsets[12]);
  object.poidsTare = reader.readDouble(offsets[13]);
  object.techCoupe = reader.readString(offsets[14]);
  object.veCode = reader.readString(offsets[15]);
  return object;
}

P _dechargerCoursDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDoubleOrNull(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dechargerCoursGetId(DechargerCours object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dechargerCoursGetLinks(DechargerCours object) {
  return [];
}

void _dechargerCoursAttach(
    IsarCollection<dynamic> col, Id id, DechargerCours object) {
  object.id = id;
}

extension DechargerCoursQueryWhereSort
    on QueryBuilder<DechargerCours, DechargerCours, QWhere> {
  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere> anyPoidsP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'poidsP1'),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere> anyPoidsTare() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'poidsTare'),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere> anyPoidsP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'poidsP2'),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere> anyDateHeureP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateHeureP1'),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere>
      anyDateHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateHeureDecharg'),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere> anyDateHeureP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateHeureP2'),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere>
      anyEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'etatSynchronisation'),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere>
      anyEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'etatModification'),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhere> anyLigneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'ligneId'),
      );
    });
  }
}

extension DechargerCoursQueryWhere
    on QueryBuilder<DechargerCours, DechargerCours, QWhereClause> {
  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause> veCodeEqualTo(
      String veCode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'veCode',
        value: [veCode],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      veCodeNotEqualTo(String veCode) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'veCode',
              lower: [],
              upper: [veCode],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'veCode',
              lower: [veCode],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'veCode',
              lower: [veCode],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'veCode',
              lower: [],
              upper: [veCode],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP1EqualTo(double poidsP1) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poidsP1',
        value: [poidsP1],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP1NotEqualTo(double poidsP1) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsP1',
              lower: [],
              upper: [poidsP1],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsP1',
              lower: [poidsP1],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsP1',
              lower: [poidsP1],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsP1',
              lower: [],
              upper: [poidsP1],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP1GreaterThan(
    double poidsP1, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsP1',
        lower: [poidsP1],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP1LessThan(
    double poidsP1, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsP1',
        lower: [],
        upper: [poidsP1],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP1Between(
    double lowerPoidsP1,
    double upperPoidsP1, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsP1',
        lower: [lowerPoidsP1],
        includeLower: includeLower,
        upper: [upperPoidsP1],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsTareEqualTo(double poidsTare) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poidsTare',
        value: [poidsTare],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsTareNotEqualTo(double poidsTare) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsTare',
              lower: [],
              upper: [poidsTare],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsTare',
              lower: [poidsTare],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsTare',
              lower: [poidsTare],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsTare',
              lower: [],
              upper: [poidsTare],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsTareGreaterThan(
    double poidsTare, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsTare',
        lower: [poidsTare],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsTareLessThan(
    double poidsTare, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsTare',
        lower: [],
        upper: [poidsTare],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsTareBetween(
    double lowerPoidsTare,
    double upperPoidsTare, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsTare',
        lower: [lowerPoidsTare],
        includeLower: includeLower,
        upper: [upperPoidsTare],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poidsP2',
        value: [null],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsP2',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP2EqualTo(double? poidsP2) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poidsP2',
        value: [poidsP2],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP2NotEqualTo(double? poidsP2) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsP2',
              lower: [],
              upper: [poidsP2],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsP2',
              lower: [poidsP2],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsP2',
              lower: [poidsP2],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poidsP2',
              lower: [],
              upper: [poidsP2],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP2GreaterThan(
    double? poidsP2, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsP2',
        lower: [poidsP2],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP2LessThan(
    double? poidsP2, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsP2',
        lower: [],
        upper: [poidsP2],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      poidsP2Between(
    double? lowerPoidsP2,
    double? upperPoidsP2, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'poidsP2',
        lower: [lowerPoidsP2],
        includeLower: includeLower,
        upper: [upperPoidsP2],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP1EqualTo(DateTime dateHeureP1) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateHeureP1',
        value: [dateHeureP1],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP1NotEqualTo(DateTime dateHeureP1) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureP1',
              lower: [],
              upper: [dateHeureP1],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureP1',
              lower: [dateHeureP1],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureP1',
              lower: [dateHeureP1],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureP1',
              lower: [],
              upper: [dateHeureP1],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP1GreaterThan(
    DateTime dateHeureP1, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureP1',
        lower: [dateHeureP1],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP1LessThan(
    DateTime dateHeureP1, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureP1',
        lower: [],
        upper: [dateHeureP1],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP1Between(
    DateTime lowerDateHeureP1,
    DateTime upperDateHeureP1, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureP1',
        lower: [lowerDateHeureP1],
        includeLower: includeLower,
        upper: [upperDateHeureP1],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureDechargEqualTo(DateTime dateHeureDecharg) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateHeureDecharg',
        value: [dateHeureDecharg],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureDechargNotEqualTo(DateTime dateHeureDecharg) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureDecharg',
              lower: [],
              upper: [dateHeureDecharg],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureDecharg',
              lower: [dateHeureDecharg],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureDecharg',
              lower: [dateHeureDecharg],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureDecharg',
              lower: [],
              upper: [dateHeureDecharg],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureDechargGreaterThan(
    DateTime dateHeureDecharg, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureDecharg',
        lower: [dateHeureDecharg],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureDechargLessThan(
    DateTime dateHeureDecharg, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureDecharg',
        lower: [],
        upper: [dateHeureDecharg],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureDechargBetween(
    DateTime lowerDateHeureDecharg,
    DateTime upperDateHeureDecharg, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureDecharg',
        lower: [lowerDateHeureDecharg],
        includeLower: includeLower,
        upper: [upperDateHeureDecharg],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateHeureP2',
        value: [null],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureP2',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP2EqualTo(DateTime? dateHeureP2) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateHeureP2',
        value: [dateHeureP2],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP2NotEqualTo(DateTime? dateHeureP2) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureP2',
              lower: [],
              upper: [dateHeureP2],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureP2',
              lower: [dateHeureP2],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureP2',
              lower: [dateHeureP2],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateHeureP2',
              lower: [],
              upper: [dateHeureP2],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP2GreaterThan(
    DateTime? dateHeureP2, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureP2',
        lower: [dateHeureP2],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP2LessThan(
    DateTime? dateHeureP2, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureP2',
        lower: [],
        upper: [dateHeureP2],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      dateHeureP2Between(
    DateTime? lowerDateHeureP2,
    DateTime? upperDateHeureP2, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateHeureP2',
        lower: [lowerDateHeureP2],
        includeLower: includeLower,
        upper: [upperDateHeureP2],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      techCoupeEqualTo(String techCoupe) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'techCoupe',
        value: [techCoupe],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      techCoupeNotEqualTo(String techCoupe) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'techCoupe',
              lower: [],
              upper: [techCoupe],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'techCoupe',
              lower: [techCoupe],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'techCoupe',
              lower: [techCoupe],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'techCoupe',
              lower: [],
              upper: [techCoupe],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      matriculeAgentEqualTo(String matriculeAgent) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'matriculeAgent',
        value: [matriculeAgent],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      matriculeAgentNotEqualTo(String matriculeAgent) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculeAgent',
              lower: [],
              upper: [matriculeAgent],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculeAgent',
              lower: [matriculeAgent],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculeAgent',
              lower: [matriculeAgent],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculeAgent',
              lower: [],
              upper: [matriculeAgent],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      etatSynchronisationEqualTo(bool etatSynchronisation) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'etatSynchronisation',
        value: [etatSynchronisation],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      etatSynchronisationNotEqualTo(bool etatSynchronisation) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatSynchronisation',
              lower: [],
              upper: [etatSynchronisation],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatSynchronisation',
              lower: [etatSynchronisation],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatSynchronisation',
              lower: [etatSynchronisation],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatSynchronisation',
              lower: [],
              upper: [etatSynchronisation],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      etatModificationEqualTo(bool etatModification) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'etatModification',
        value: [etatModification],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      etatModificationNotEqualTo(bool etatModification) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatModification',
              lower: [],
              upper: [etatModification],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatModification',
              lower: [etatModification],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatModification',
              lower: [etatModification],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'etatModification',
              lower: [],
              upper: [etatModification],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      ligneIdEqualTo(int ligneId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ligneId',
        value: [ligneId],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      ligneIdNotEqualTo(int ligneId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ligneId',
              lower: [],
              upper: [ligneId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ligneId',
              lower: [ligneId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ligneId',
              lower: [ligneId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ligneId',
              lower: [],
              upper: [ligneId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      ligneIdGreaterThan(
    int ligneId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ligneId',
        lower: [ligneId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      ligneIdLessThan(
    int ligneId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ligneId',
        lower: [],
        upper: [ligneId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterWhereClause>
      ligneIdBetween(
    int lowerLigneId,
    int upperLigneId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ligneId',
        lower: [lowerLigneId],
        includeLower: includeLower,
        upper: [upperLigneId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DechargerCoursQueryFilter
    on QueryBuilder<DechargerCours, DechargerCours, QFilterCondition> {
  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureDechargEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateHeureDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureDechargGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateHeureDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureDechargLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateHeureDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureDechargBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateHeureDecharg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP1EqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateHeureP1',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP1GreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateHeureP1',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP1LessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateHeureP1',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP1Between(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateHeureP1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateHeureP2',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateHeureP2',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP2EqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateHeureP2',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP2GreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateHeureP2',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP2LessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateHeureP2',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      dateHeureP2Between(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateHeureP2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      etatAffectationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatAffectation',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      etatBroyageEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatBroyage',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      etatModificationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatModification',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      etatSynchronisationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatSynchronisation',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      ligneIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ligneId',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      ligneIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ligneId',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      ligneIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ligneId',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      ligneIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ligneId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matriculeAgent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matriculeAgent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matriculeAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      matriculeAgentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matriculeAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parcelle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parcelle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parcelle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parcelle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parcelle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parcelle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parcelle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parcelle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parcelle',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      parcelleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parcelle',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsNetEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poidsNet',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsNetGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poidsNet',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsNetLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poidsNet',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsNetBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poidsNet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP1EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poidsP1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP1GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poidsP1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP1LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poidsP1',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP1Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poidsP1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'poidsP2',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'poidsP2',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP2EqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poidsP2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP2GreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poidsP2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP2LessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poidsP2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsP2Between(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poidsP2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsTareEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poidsTare',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsTareGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poidsTare',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsTareLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poidsTare',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      poidsTareBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poidsTare',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'techCoupe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'techCoupe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'techCoupe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'techCoupe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'techCoupe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'techCoupe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'techCoupe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'techCoupe',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'techCoupe',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      techCoupeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'techCoupe',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'veCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'veCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'veCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'veCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'veCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'veCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'veCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'veCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'veCode',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterFilterCondition>
      veCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'veCode',
        value: '',
      ));
    });
  }
}

extension DechargerCoursQueryObject
    on QueryBuilder<DechargerCours, DechargerCours, QFilterCondition> {}

extension DechargerCoursQueryLinks
    on QueryBuilder<DechargerCours, DechargerCours, QFilterCondition> {}

extension DechargerCoursQuerySortBy
    on QueryBuilder<DechargerCours, DechargerCours, QSortBy> {
  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByDateHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureDecharg', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByDateHeureDechargDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureDecharg', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByDateHeureP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP1', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByDateHeureP1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP1', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByDateHeureP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP2', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByDateHeureP2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP2', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByEtatAffectation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatAffectation', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByEtatAffectationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatAffectation', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByEtatBroyage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatBroyage', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByEtatBroyageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatBroyage', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByEtatModificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByEtatSynchronisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> sortByLigneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ligneId', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByLigneIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ligneId', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByMatriculeAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByMatriculeAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> sortByParcelle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelle', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByParcelleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelle', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> sortByPoidsNet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsNet', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByPoidsNetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsNet', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> sortByPoidsP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP1', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByPoidsP1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP1', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> sortByPoidsP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP2', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByPoidsP2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP2', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> sortByPoidsTare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTare', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByPoidsTareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTare', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> sortByTechCoupe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'techCoupe', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByTechCoupeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'techCoupe', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> sortByVeCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veCode', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      sortByVeCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veCode', Sort.desc);
    });
  }
}

extension DechargerCoursQuerySortThenBy
    on QueryBuilder<DechargerCours, DechargerCours, QSortThenBy> {
  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByDateHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureDecharg', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByDateHeureDechargDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureDecharg', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByDateHeureP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP1', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByDateHeureP1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP1', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByDateHeureP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP2', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByDateHeureP2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP2', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByEtatAffectation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatAffectation', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByEtatAffectationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatAffectation', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByEtatBroyage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatBroyage', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByEtatBroyageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatBroyage', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByEtatModificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByEtatSynchronisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByLigneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ligneId', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByLigneIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ligneId', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByMatriculeAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByMatriculeAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByParcelle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelle', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByParcelleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelle', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByPoidsNet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsNet', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByPoidsNetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsNet', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByPoidsP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP1', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByPoidsP1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP1', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByPoidsP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP2', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByPoidsP2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP2', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByPoidsTare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTare', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByPoidsTareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTare', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByTechCoupe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'techCoupe', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByTechCoupeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'techCoupe', Sort.desc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy> thenByVeCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veCode', Sort.asc);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QAfterSortBy>
      thenByVeCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veCode', Sort.desc);
    });
  }
}

extension DechargerCoursQueryWhereDistinct
    on QueryBuilder<DechargerCours, DechargerCours, QDistinct> {
  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByDateHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateHeureDecharg');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByDateHeureP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateHeureP1');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByDateHeureP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateHeureP2');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByEtatAffectation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatAffectation');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByEtatBroyage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatBroyage');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatModification');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatSynchronisation');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct> distinctByLigneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ligneId');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByMatriculeAgent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matriculeAgent',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct> distinctByParcelle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parcelle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct> distinctByPoidsNet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsNet');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct> distinctByPoidsP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsP1');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct> distinctByPoidsP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsP2');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct>
      distinctByPoidsTare() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsTare');
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct> distinctByTechCoupe(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'techCoupe', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DechargerCours, DechargerCours, QDistinct> distinctByVeCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'veCode', caseSensitive: caseSensitive);
    });
  }
}

extension DechargerCoursQueryProperty
    on QueryBuilder<DechargerCours, DechargerCours, QQueryProperty> {
  QueryBuilder<DechargerCours, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DechargerCours, DateTime, QQueryOperations>
      dateHeureDechargProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateHeureDecharg');
    });
  }

  QueryBuilder<DechargerCours, DateTime, QQueryOperations>
      dateHeureP1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateHeureP1');
    });
  }

  QueryBuilder<DechargerCours, DateTime?, QQueryOperations>
      dateHeureP2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateHeureP2');
    });
  }

  QueryBuilder<DechargerCours, bool, QQueryOperations>
      etatAffectationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatAffectation');
    });
  }

  QueryBuilder<DechargerCours, bool, QQueryOperations> etatBroyageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatBroyage');
    });
  }

  QueryBuilder<DechargerCours, bool, QQueryOperations>
      etatModificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatModification');
    });
  }

  QueryBuilder<DechargerCours, bool, QQueryOperations>
      etatSynchronisationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatSynchronisation');
    });
  }

  QueryBuilder<DechargerCours, int, QQueryOperations> ligneIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ligneId');
    });
  }

  QueryBuilder<DechargerCours, String, QQueryOperations>
      matriculeAgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matriculeAgent');
    });
  }

  QueryBuilder<DechargerCours, String, QQueryOperations> parcelleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parcelle');
    });
  }

  QueryBuilder<DechargerCours, double, QQueryOperations> poidsNetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsNet');
    });
  }

  QueryBuilder<DechargerCours, double, QQueryOperations> poidsP1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsP1');
    });
  }

  QueryBuilder<DechargerCours, double?, QQueryOperations> poidsP2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsP2');
    });
  }

  QueryBuilder<DechargerCours, double, QQueryOperations> poidsTareProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsTare');
    });
  }

  QueryBuilder<DechargerCours, String, QQueryOperations> techCoupeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'techCoupe');
    });
  }

  QueryBuilder<DechargerCours, String, QQueryOperations> veCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'veCode');
    });
  }
}
