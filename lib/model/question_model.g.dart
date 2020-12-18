// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 0;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      categoryId: fields[0] as int,
      categoryName: fields[1] as String,
      correctAnswer: fields[2] as int,
      explanation: fields[3] as String,
      explanationVi: fields[4] as String,
      groupId: fields[5] as String,
      id: fields[6] as int,
      level: fields[7] as int,
      options: fields[8] as String,
      task: fields[9] as String,
      currentChecked: fields[10] as Rx<int>,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.categoryId)
      ..writeByte(1)
      ..write(obj.categoryName)
      ..writeByte(2)
      ..write(obj.correctAnswer)
      ..writeByte(3)
      ..write(obj.explanation)
      ..writeByte(4)
      ..write(obj.explanationVi)
      ..writeByte(5)
      ..write(obj.groupId)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.options)
      ..writeByte(9)
      ..write(obj.task)
      ..writeByte(10)
      ..write(obj.currentChecked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
