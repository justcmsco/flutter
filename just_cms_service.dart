import 'dart:convert';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// Model Classes
// ---------------------------------------------------------------------------

class Category {
  final String name;
  final String slug;

  Category({required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      slug: json['slug'],
    );
  }
}

class CategoriesResponse {
  final List<Category> categories;

  CategoriesResponse({required this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    var categoriesJson = json['categories'] as List;
    List<Category> categories =
        categoriesJson.map((e) => Category.fromJson(e)).toList();
    return CategoriesResponse(categories: categories);
  }
}

class ImageVariant {
  final String url;
  final int width;
  final int height;
  final String filename;

  ImageVariant({
    required this.url,
    required this.width,
    required this.height,
    required this.filename,
  });

  factory ImageVariant.fromJson(Map<String, dynamic> json) {
    return ImageVariant(
      url: json['url'],
      width: json['width'],
      height: json['height'],
      filename: json['filename'],
    );
  }
}

/// In order to avoid any naming conflict with Flutter's own Image widget,
/// we use the name `CmsImage` for the JustCMS image model.
class CmsImage {
  final String alt;
  final List<ImageVariant> variants;

  CmsImage({required this.alt, required this.variants});

  factory CmsImage.fromJson(Map<String, dynamic> json) {
    var variantsJson = json['variants'] as List;
    List<ImageVariant> variants =
        variantsJson.map((e) => ImageVariant.fromJson(e)).toList();
    return CmsImage(
      alt: json['alt'],
      variants: variants,
    );
  }
}

class Meta {
  final String title;
  final String description;

  Meta({required this.title, required this.description});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      title: json['title'],
      description: json['description'],
    );
  }
}

class PageSummary {
  final String title;
  final String subtitle;
  final CmsImage? coverImage;
  final String slug;
  final List<Category> categories;
  final String createdAt;
  final String updatedAt;

  PageSummary({
    required this.title,
    required this.subtitle,
    this.coverImage,
    required this.slug,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PageSummary.fromJson(Map<String, dynamic> json) {
    var categoriesJson = json['categories'] as List;
    List<Category> categories =
        categoriesJson.map((e) => Category.fromJson(e)).toList();
    return PageSummary(
      title: json['title'],
      subtitle: json['subtitle'],
      coverImage:
          json['coverImage'] != null ? CmsImage.fromJson(json['coverImage']) : null,
      slug: json['slug'],
      categories: categories,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class PagesResponse {
  final List<PageSummary> items;
  final int total;

  PagesResponse({required this.items, required this.total});

  factory PagesResponse.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<PageSummary> items =
        itemsJson.map((e) => PageSummary.fromJson(e)).toList();
    return PagesResponse(
      items: items,
      total: json['total'],
    );
  }
}

// ---------------------------------------------------------------------------
// Content Block Models
// ---------------------------------------------------------------------------

/// An abstract base class for all content blocks.
abstract class ContentBlock {
  String get type;
  List<String> get styles;

  ContentBlock({required this.styles});

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'header':
        return HeaderBlock.fromJson(json);
      case 'list':
        return ListBlock.fromJson(json);
      case 'embed':
        return EmbedBlock.fromJson(json);
      case 'image':
        return ImageBlock.fromJson(json);
      case 'code':
        return CodeBlock.fromJson(json);
      case 'text':
        return TextBlock.fromJson(json);
      case 'cta':
        return CtaBlock.fromJson(json);
      case 'custom':
        return CustomBlock.fromJson(json);
      default:
        throw Exception('Unknown content block type: $type');
    }
  }
}

class HeaderBlock extends ContentBlock {
  @override
  final String type;
  final String header;
  final String? subheader;
  final String size;
  @override
  final List<String> styles;

  HeaderBlock({
    required this.header,
    this.subheader,
    required this.size,
    required this.styles,
  })  : type = 'header',
        super(styles: styles);

  factory HeaderBlock.fromJson(Map<String, dynamic> json) {
    return HeaderBlock(
      header: json['header'],
      subheader: json['subheader'],
      size: json['size'],
      styles: List<String>.from(json['styles'] ?? []),
    );
  }
}

class ListOption {
  final String title;
  final String? subtitle;

  ListOption({required this.title, this.subtitle});

  factory ListOption.fromJson(Map<String, dynamic> json) {
    return ListOption(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }
}

class ListBlock extends ContentBlock {
  @override
  final String type;
  final List<ListOption> options;
  @override
  final List<String> styles;

  ListBlock({
    required this.options,
    required this.styles,
  })  : type = 'list',
        super(styles: styles);

  factory ListBlock.fromJson(Map<String, dynamic> json) {
    var optionsJson = json['options'] as List;
    List<ListOption> options =
        optionsJson.map((e) => ListOption.fromJson(e)).toList();
    return ListBlock(
      options: options,
      styles: List<String>.from(json['styles'] ?? []),
    );
  }
}

class EmbedBlock extends ContentBlock {
  @override
  final String type;
  final String url;
  @override
  final List<String> styles;

  EmbedBlock({
    required this.url,
    required this.styles,
  })  : type = 'embed',
        super(styles: styles);

  factory EmbedBlock.fromJson(Map<String, dynamic> json) {
    return EmbedBlock(
      url: json['url'],
      styles: List<String>.from(json['styles'] ?? []),
    );
  }
}

class ImageBlock extends ContentBlock {
  @override
  final String type;
  final List<CmsImage> images;
  @override
  final List<String> styles;

  ImageBlock({
    required this.images,
    required this.styles,
  })  : type = 'image',
        super(styles: styles);

  factory ImageBlock.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['images'] as List;
    List<CmsImage> images =
        imagesJson.map((e) => CmsImage.fromJson(e)).toList();
    return ImageBlock(
      images: images,
      styles: List<String>.from(json['styles'] ?? []),
    );
  }
}

class CodeBlock extends ContentBlock {
  @override
  final String type;
  final String code;
  @override
  final List<String> styles;

  CodeBlock({
    required this.code,
    required this.styles,
  })  : type = 'code',
        super(styles: styles);

  factory CodeBlock.fromJson(Map<String, dynamic> json) {
    return CodeBlock(
      code: json['code'],
      styles: List<String>.from(json['styles'] ?? []),
    );
  }
}

class TextBlock extends ContentBlock {
  @override
  final String type;
  final String text;
  @override
  final List<String> styles;

  TextBlock({
    required this.text,
    required this.styles,
  })  : type = 'text',
        super(styles: styles);

  factory TextBlock.fromJson(Map<String, dynamic> json) {
    return TextBlock(
      text: json['text'],
      styles: List<String>.from(json['styles'] ?? []),
    );
  }
}

class CtaBlock extends ContentBlock {
  @override
  final String type;
  final String text;
  final String url;
  final String? description;
  @override
  final List<String> styles;

  CtaBlock({
    required this.text,
    required this.url,
    this.description,
    required this.styles,
  })  : type = 'cta',
        super(styles: styles);

  factory CtaBlock.fromJson(Map<String, dynamic> json) {
    return CtaBlock(
      text: json['text'],
      url: json['url'],
      description: json['description'],
      styles: List<String>.from(json['styles'] ?? []),
    );
  }
}

class CustomBlock extends ContentBlock {
  @override
  final String type;
  final String blockId;
  final Map<String, dynamic> additionalData;
  @override
  final List<String> styles;

  CustomBlock({
    required this.blockId,
    required this.additionalData,
    required this.styles,
  })  : type = 'custom',
        super(styles: styles);

  factory CustomBlock.fromJson(Map<String, dynamic> json) {
    // Remove known keys so that the rest becomes additional data.
    var data = Map<String, dynamic>.from(json);
    data.remove('type');
    data.remove('styles');
    data.remove('blockId');
    return CustomBlock(
      blockId: json['blockId'],
      additionalData: data,
      styles: List<String>.from(json['styles'] ?? []),
    );
  }
}

class PageDetail {
  final String title;
  final String subtitle;
  final Meta meta;
  final CmsImage? coverImage;
  final String slug;
  final List<Category> categories;
  final List<ContentBlock> content;
  final String createdAt;
  final String updatedAt;

  PageDetail({
    required this.title,
    required this.subtitle,
    required this.meta,
    this.coverImage,
    required this.slug,
    required this.categories,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) {
    var categoriesJson = json['categories'] as List;
    List<Category> categories =
        categoriesJson.map((e) => Category.fromJson(e)).toList();
    var contentJson = json['content'] as List;
    List<ContentBlock> content =
        contentJson.map((e) => ContentBlock.fromJson(e)).toList();
    return PageDetail(
      title: json['title'],
      subtitle: json['subtitle'],
      meta: Meta.fromJson(json['meta']),
      coverImage:
          json['coverImage'] != null ? CmsImage.fromJson(json['coverImage']) : null,
      slug: json['slug'],
      categories: categories,
      content: content,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class MenuItem {
  final String title;
  final String? subtitle;
  final String icon;
  final String url;
  final List<String> styles;
  final List<MenuItem> children;

  MenuItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.url,
    required this.styles,
    required this.children,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    var childrenJson = json['children'] as List? ?? [];
    List<MenuItem> children =
        childrenJson.map((e) => MenuItem.fromJson(e)).toList();
    return MenuItem(
      title: json['title'],
      subtitle: json['subtitle'],
      icon: json['icon'],
      url: json['url'],
      styles: List<String>.from(json['styles'] ?? []),
      children: children,
    );
  }
}

class Menu {
  final String id;
  final String name;
  final List<MenuItem> items;

  Menu({
    required this.id,
    required this.name,
    required this.items,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<MenuItem> items =
        itemsJson.map((e) => MenuItem.fromJson(e)).toList();
    return Menu(
      id: json['id'],
      name: json['name'],
      items: items,
    );
  }
}

// ---------------------------------------------------------------------------
// JustCMS Service
// ---------------------------------------------------------------------------

class JustCMSService {
  final String token;
  final String projectId;
  final String baseUrl = 'https://api.justcms.co/public';

  JustCMSService({required this.token, required this.projectId});

  /// A private helper to make GET requests to a given JustCMS endpoint.
  Future<T> _get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final uri = Uri.parse(
            '$baseUrl/$projectId${endpoint.isNotEmpty ? '/$endpoint' : ''}')
        .replace(
      queryParameters:
          queryParams?.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('JustCMS API error ${response.statusCode}: ${response.body}');
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return fromJson(jsonResponse);
  }

  /// Retrieves all categories.
  Future<List<Category>> getCategories() async {
    final categoriesResponse = await _get(
      '',
      fromJson: (json) => CategoriesResponse.fromJson(json),
    );
    return categoriesResponse.categories;
  }

  /// Retrieves pages with optional filtering and pagination.
  ///
  /// [filterCategorySlug] – filters pages by a category slug.
  /// [start] – pagination start index.
  /// [offset] – number of items to return.
  Future<PagesResponse> getPages({String? filterCategorySlug, int? start, int? offset}) async {
    final Map<String, dynamic> query = {};
    if (filterCategorySlug != null) {
      query['filter.category.slug'] = filterCategorySlug;
    }
    if (start != null) {
      query['start'] = start;
    }
    if (offset != null) {
      query['offset'] = offset;
    }
    return await _get(
      'pages',
      queryParams: query,
      fromJson: (json) => PagesResponse.fromJson(json),
    );
  }

  /// Retrieves a single page by its slug.
  ///
  /// Optionally pass a [version] (e.g. 'draft') to fetch a specific version.
  Future<PageDetail> getPageBySlug(String slug, {String? version}) async {
    final Map<String, dynamic> query = {};
    if (version != null) {
      query['v'] = version;
    }
    return await _get(
      'pages/$slug',
      queryParams: query,
      fromJson: (json) => PageDetail.fromJson(json),
    );
  }

  /// Retrieves a menu by its ID.
  Future<Menu> getMenuById(String id) async {
    return await _get(
      'menus/$id',
      fromJson: (json) => Menu.fromJson(json),
    );
  }

  // -------------------------------------------------------------------------
  // Utility Functions
  // -------------------------------------------------------------------------

  /// Checks if a content block has a specific style (case-insensitive).
  bool isBlockHasStyle(ContentBlock block, String style) {
    return block.styles.any((s) => s.toLowerCase() == style.toLowerCase());
  }

  /// Gets the large image variant from a [CmsImage].
  ///
  /// Returns `null` if the large variant is not available.
  ImageVariant? getLargeImageVariant(CmsImage image) {
    if (image.variants.length > 1) {
      return image.variants[1];
    }
    return null;
  }

  /// Gets the first image from an [ImageBlock].
  ///
  /// Returns `null` if no images are available.
  CmsImage? getFirstImage(ImageBlock block) {
    if (block.images.isNotEmpty) {
      return block.images.first;
    }
    return null;
  }

  /// Checks if a [PageDetail] belongs to a specific category by [categorySlug].
  bool hasCategory(PageDetail page, String categorySlug) {
    return page.categories.any((cat) => cat.slug == categorySlug);
  }
}
