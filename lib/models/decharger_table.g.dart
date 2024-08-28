// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decharger_table.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDechargerTableCollection on Isar {
  IsarCollection<DechargerTable> get dechargerTables => this.collection();
}

const DechargerTableSchema = CollectionSchema(
  name: r'DechargerTable',
  id: 8386696169911744923,
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
    r'etatModification': PropertySchema(
      id: 3,
      name: r'etatModification',
      type: IsarType.bool,
    ),
    r'etatSynchronisation': PropertySchema(
      id: 4,
      name: r'etatSynchronisation',
      type: IsarType.bool,
    ),
    r'matriculeAgent': PropertySchema(
      id: 5,
      name: r'matriculeAgent',
      type: IsarType.string,
    ),
    r'parcelle': PropertySchema(
      id: 6,
      name: r'parcelle',
      type: IsarType.string,
    ),
    r'poidsNet': PropertySchema(
      id: 7,
      name: r'poidsNet',
      type: IsarType.double,
    ),
    r'poidsP1': PropertySchema(
      id: 8,
      name: r'poidsP1',
      type: IsarType.double,
    ),
    r'poidsP2': PropertySchema(
      id: 9,
      name: r'poidsP2',
      type: IsarType.double,
    ),
    r'poidsTare': PropertySchema(
      id: 10,
      name: r'poidsTare',
      type: IsarType.double,
    ),
    r'techCoupe': PropertySchema(
      id: 11,
      name: r'techCoupe',
      type: IsarType.string,
    ),
    r'veCode': PropertySchema(
      id: 12,
      name: r'veCode',
      type: IsarType.string,
    )
  },
  estimateSize: _dechargerTableEstimateSize,
  serialize: _dechargerTableSerialize,
  deserialize: _dechargerTableDeserialize,
  deserializeProp: _dechargerTableDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dechargerTableGetId,
  getLinks: _dechargerTableGetLinks,
  attach: _dechargerTableAttach,
  version: '3.1.0+1',
);

int _dechargerTableEstimateSize(
  DechargerTable object,
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

void _dechargerTableSerialize(
  DechargerTable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateHeureDecharg);
  writer.writeDateTime(offsets[1], object.dateHeureP1);
  writer.writeDateTime(offsets[2], object.dateHeureP2);
  writer.writeBool(offsets[3], object.etatModification);
  writer.writeBool(offsets[4], object.etatSynchronisation);
  writer.writeString(offsets[5], object.matriculeAgent);
  writer.writeString(offsets[6], object.parcelle);
  writer.writeDouble(offsets[7], object.poidsNet);
  writer.writeDouble(offsets[8], object.poidsP1);
  writer.writeDouble(offsets[9], object.poidsP2);
  writer.writeDouble(offsets[10], object.poidsTare);
  writer.writeString(offsets[11], object.techCoupe);
  writer.writeString(offsets[12], object.veCode);
}

DechargerTable _dechargerTableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DechargerTable();
  object.dateHeureDecharg = reader.readDateTime(offsets[0]);
  object.dateHeureP1 = reader.readDateTime(offsets[1]);
  object.dateHeureP2 = reader.readDateTimeOrNull(offsets[2]);
  object.etatModification = reader.readBool(offsets[3]);
  object.etatSynchronisation = reader.readBool(offsets[4]);
  object.id = id;
  object.matriculeAgent = reader.readString(offsets[5]);
  object.parcelle = reader.readString(offsets[6]);
  object.poidsP1 = reader.readDouble(offsets[8]);
  object.poidsP2 = reader.readDoubleOrNull(offsets[9]);
  object.poidsTare = reader.readDouble(offsets[10]);
  object.techCoupe = reader.readString(offsets[11]);
  object.veCode = reader.readString(offsets[12]);
  return object;
}

P _dechargerTableDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dechargerTableGetId(DechargerTable object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dechargerTableGetLinks(DechargerTable object) {
  return [];
}

void _dechargerTableAttach(
    IsarCollection<dynamic> col, Id id, DechargerTable object) {
  object.id = id;
}

extension DechargerTableQueryWhereSort
    on QueryBuilder<DechargerTable, DechargerTable, QWhere> {
  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere> anyPoidsP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'poidsP1'),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere> anyPoidsTare() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'poidsTare'),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere> anyPoidsP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'poidsP2'),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere> anyDateHeureP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateHeureP1'),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere>
      anyDateHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateHeureDecharg'),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere> anyDateHeureP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateHeureP2'),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere>
      anyEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'etatSynchronisation'),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhere>
      anyEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'etatModification'),
      );
    });
  }
}

extension DechargerTableQueryWhere
    on QueryBuilder<DechargerTable, DechargerTable, QWhereClause> {
  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause> idBetween(
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause> veCodeEqualTo(
      String veCode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'veCode',
        value: [veCode],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      poidsP1EqualTo(double poidsP1) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poidsP1',
        value: [poidsP1],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      poidsTareEqualTo(double poidsTare) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poidsTare',
        value: [poidsTare],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      poidsP2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poidsP2',
        value: [null],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      poidsP2EqualTo(double? poidsP2) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poidsP2',
        value: [poidsP2],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      dateHeureP1EqualTo(DateTime dateHeureP1) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateHeureP1',
        value: [dateHeureP1],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      dateHeureDechargEqualTo(DateTime dateHeureDecharg) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateHeureDecharg',
        value: [dateHeureDecharg],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      dateHeureP2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateHeureP2',
        value: [null],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      dateHeureP2EqualTo(DateTime? dateHeureP2) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateHeureP2',
        value: [dateHeureP2],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      matriculeAgentEqualTo(String matriculeAgent) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'matriculeAgent',
        value: [matriculeAgent],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      etatSynchronisationEqualTo(bool etatSynchronisation) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'etatSynchronisation',
        value: [etatSynchronisation],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
      etatModificationEqualTo(bool etatModification) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'etatModification',
        value: [etatModification],
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterWhereClause>
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
}

extension DechargerTableQueryFilter
    on QueryBuilder<DechargerTable, DechargerTable, QFilterCondition> {
  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      dateHeureDechargEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateHeureDecharg',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      dateHeureP1EqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateHeureP1',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      dateHeureP2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateHeureP2',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      dateHeureP2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateHeureP2',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      dateHeureP2EqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateHeureP2',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      etatModificationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatModification',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      etatSynchronisationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etatSynchronisation',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      matriculeAgentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matriculeAgent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      matriculeAgentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matriculeAgent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      matriculeAgentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matriculeAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      matriculeAgentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matriculeAgent',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      parcelleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parcelle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      parcelleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parcelle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      parcelleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parcelle',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      parcelleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parcelle',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      poidsP2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'poidsP2',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      poidsP2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'poidsP2',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      techCoupeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'techCoupe',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      techCoupeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'techCoupe',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      techCoupeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'techCoupe',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      techCoupeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'techCoupe',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
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

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      veCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'veCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      veCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'veCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      veCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'veCode',
        value: '',
      ));
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterFilterCondition>
      veCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'veCode',
        value: '',
      ));
    });
  }
}

extension DechargerTableQueryObject
    on QueryBuilder<DechargerTable, DechargerTable, QFilterCondition> {}

extension DechargerTableQueryLinks
    on QueryBuilder<DechargerTable, DechargerTable, QFilterCondition> {}

extension DechargerTableQuerySortBy
    on QueryBuilder<DechargerTable, DechargerTable, QSortBy> {
  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByDateHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureDecharg', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByDateHeureDechargDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureDecharg', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByDateHeureP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP1', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByDateHeureP1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP1', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByDateHeureP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP2', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByDateHeureP2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP2', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByEtatModificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByEtatSynchronisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByMatriculeAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByMatriculeAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> sortByParcelle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelle', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByParcelleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelle', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> sortByPoidsNet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsNet', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByPoidsNetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsNet', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> sortByPoidsP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP1', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByPoidsP1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP1', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> sortByPoidsP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP2', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByPoidsP2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP2', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> sortByPoidsTare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTare', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByPoidsTareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTare', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> sortByTechCoupe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'techCoupe', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByTechCoupeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'techCoupe', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> sortByVeCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veCode', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      sortByVeCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veCode', Sort.desc);
    });
  }
}

extension DechargerTableQuerySortThenBy
    on QueryBuilder<DechargerTable, DechargerTable, QSortThenBy> {
  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByDateHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureDecharg', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByDateHeureDechargDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureDecharg', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByDateHeureP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP1', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByDateHeureP1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP1', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByDateHeureP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP2', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByDateHeureP2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateHeureP2', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByEtatModificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatModification', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByEtatSynchronisationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'etatSynchronisation', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByMatriculeAgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByMatriculeAgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculeAgent', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenByParcelle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelle', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByParcelleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelle', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenByPoidsNet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsNet', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByPoidsNetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsNet', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenByPoidsP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP1', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByPoidsP1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP1', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenByPoidsP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP2', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByPoidsP2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsP2', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenByPoidsTare() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTare', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByPoidsTareDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poidsTare', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenByTechCoupe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'techCoupe', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByTechCoupeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'techCoupe', Sort.desc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy> thenByVeCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veCode', Sort.asc);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QAfterSortBy>
      thenByVeCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veCode', Sort.desc);
    });
  }
}

extension DechargerTableQueryWhereDistinct
    on QueryBuilder<DechargerTable, DechargerTable, QDistinct> {
  QueryBuilder<DechargerTable, DechargerTable, QDistinct>
      distinctByDateHeureDecharg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateHeureDecharg');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct>
      distinctByDateHeureP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateHeureP1');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct>
      distinctByDateHeureP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateHeureP2');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct>
      distinctByEtatModification() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatModification');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct>
      distinctByEtatSynchronisation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'etatSynchronisation');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct>
      distinctByMatriculeAgent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matriculeAgent',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct> distinctByParcelle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parcelle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct> distinctByPoidsNet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsNet');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct> distinctByPoidsP1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsP1');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct> distinctByPoidsP2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsP2');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct>
      distinctByPoidsTare() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poidsTare');
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct> distinctByTechCoupe(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'techCoupe', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DechargerTable, DechargerTable, QDistinct> distinctByVeCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'veCode', caseSensitive: caseSensitive);
    });
  }
}

extension DechargerTableQueryProperty
    on QueryBuilder<DechargerTable, DechargerTable, QQueryProperty> {
  QueryBuilder<DechargerTable, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DechargerTable, DateTime, QQueryOperations>
      dateHeureDechargProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateHeureDecharg');
    });
  }

  QueryBuilder<DechargerTable, DateTime, QQueryOperations>
      dateHeureP1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateHeureP1');
    });
  }

  QueryBuilder<DechargerTable, DateTime?, QQueryOperations>
      dateHeureP2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateHeureP2');
    });
  }

  QueryBuilder<DechargerTable, bool, QQueryOperations>
      etatModificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatModification');
    });
  }

  QueryBuilder<DechargerTable, bool, QQueryOperations>
      etatSynchronisationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'etatSynchronisation');
    });
  }

  QueryBuilder<DechargerTable, String, QQueryOperations>
      matriculeAgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matriculeAgent');
    });
  }

  QueryBuilder<DechargerTable, String, QQueryOperations> parcelleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parcelle');
    });
  }

  QueryBuilder<DechargerTable, double, QQueryOperations> poidsNetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsNet');
    });
  }

  QueryBuilder<DechargerTable, double, QQueryOperations> poidsP1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsP1');
    });
  }

  QueryBuilder<DechargerTable, double?, QQueryOperations> poidsP2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsP2');
    });
  }

  QueryBuilder<DechargerTable, double, QQueryOperations> poidsTareProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poidsTare');
    });
  }

  QueryBuilder<DechargerTable, String, QQueryOperations> techCoupeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'techCoupe');
    });
  }

  QueryBuilder<DechargerTable, String, QQueryOperations> veCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'veCode');
    });
  }
}
