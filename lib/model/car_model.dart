class CarModel {
  String? id;
  String? type;
  String? year;
  String? make;
  String? model;
  String? submodel;
  String? engine;
  String? typeId;
  String? yearId;
  String? makeId;
  String? modelId;
  String? submodelId;
  String? engineId;

  CarModel(
      {this.id,
        this.type,
        this.year,
        this.make,
        this.model,
        this.submodel,
        this.engine,
        this.typeId,
        this.yearId,
        this.makeId,
        this.modelId,
        this.submodelId,
        this.engineId});

  CarModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    type = json['Type'];
    year = json['Year'];
    make = json['Make'];
    model = json['Model'];
    submodel = json['Submodel'];
    engine = json['Engine'];
    typeId = json['TypeId'];
    yearId = json['YearId'];
    makeId = json['MakeId'];
    modelId = json['ModelId'];
    submodelId = json['SubmodelId'];
    engineId = json['EngineId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Type'] = this.type;
    data['Year'] = this.year;
    data['Make'] = this.make;
    data['Model'] = this.model;
    data['Submodel'] = this.submodel;
    data['Engine'] = this.engine;
    data['TypeId'] = this.typeId;
    data['YearId'] = this.yearId;
    data['MakeId'] = this.makeId;
    data['ModelId'] = this.modelId;
    data['SubmodelId'] = this.submodelId;
    data['EngineId'] = this.engineId;
    return data;
  }

  String obtainCarModelStr() {
    return "${make} ${model} ${submodel}";
  }

  String obtainCarAttribute() {
    return "${typeId}_${yearId}_${makeId}_${modelId}_${submodelId}_${engineId}";
  }
}
