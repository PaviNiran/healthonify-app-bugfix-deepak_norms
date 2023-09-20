class LiveWellCategories {
  String? name;
  String? description;
  String? parentCategoryId;
  String? id;

  LiveWellCategories({
    this.description,
    this.name,
    this.parentCategoryId,
    this.id,
  });
}

class ContentModel {
  String? id;
  String? title;
  String? description;
  String? mediaLink;
  String? type;
  String? thumbnail;

  ContentModel({
    this.id,
    this.description,
    this.mediaLink,
    this.thumbnail,
    this.title,
    this.type,
  });
}
