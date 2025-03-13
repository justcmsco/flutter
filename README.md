# JustCMS Flutter Integration

A simple, type-safe integration for [JustCMS](https://justcms.co) in your Flutter project. This integration provides a dedicated service class (`JustCMSService`) that wraps the JustCMS public API endpoints, making it easy to fetch categories, pages, page details, and menus.

## Features

- **Strongly Typed Models:** Fully typed model classes for API responses.
- **Dedicated Service:** All JustCMS API calls are encapsulated in one service class.
- **Easy Integration:** Simply instantiate the service with your API token and project ID.
- **Flexible Endpoints:** Supports fetching categories, pages (with filtering and pagination), a page by its slug, a menu by its ID, and layouts (single or multiple).
- **Utility Methods:** Helpful functions for working with content blocks and images.

## Installation

1. **Add the Service File**

   Copy the `just_cms_service.dart` file into your project's services or lib directory.

2. **Add Dependencies**

   Add the [http](https://pub.dev/packages/http) package to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     http: ^0.13.0
   ```

3. **Install Packages**

   Run the following command to install the dependencies:

   ```bash
   flutter pub get
   ```

## Configuration

When creating an instance of `JustCMSService`, provide your JustCMS API token and project ID:

```dart
final justCmsService = JustCMSService(
  token: 'YOUR_JUSTCMS_API_TOKEN',
  projectId: 'YOUR_JUSTCMS_PROJECT_ID',
);
```

- **token:** Your JustCMS API token required for authentication.
- **projectId:** Your JustCMS project ID.

## Usage

You can now call the methods on `JustCMSService` to fetch data from JustCMS.

### Example: Fetching Categories

Below is a simple example that fetches and displays categories in a Flutter widget:

```dart
import 'package:flutter/material.dart';
import 'just_cms_service.dart'; // Adjust the import path as needed

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final justCmsService = JustCMSService(
    token: 'YOUR_JUSTCMS_API_TOKEN',
    projectId: 'YOUR_JUSTCMS_PROJECT_ID',
  );
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = justCmsService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories found.'));
          }
          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return ListTile(
                title: Text(cat.name),
              );
            },
          );
        },
      ),
    );
  }
}
```

### Available Methods

The `JustCMSService` class provides the following methods:

- **getCategories()**

  Fetches all categories.

  ```dart
  Future<List<Category>> categories = justCmsService.getCategories();
  ```

- **getPages({String? filterCategorySlug, int? start, int? offset})**

  Fetches pages with optional filtering (by category slug) and pagination.

  ```dart
  Future<PagesResponse> pagesResponse = justCmsService.getPages(
    filterCategorySlug: 'blog',
    start: 0,
    offset: 10,
  );
  ```

- **getPageBySlug(String slug, {String? version})**

  Fetches detailed information about a page by its slug. You can optionally pass a version (e.g., 'draft').

  ```dart
  Future<PageDetail> pageDetail = justCmsService.getPageBySlug('about-us');
  ```

- **getMenuById(String id)**

  Fetches a menu and its items by the given ID.

  ```dart
  Future<Menu> menu = justCmsService.getMenuById('main-menu');
  ```

- **getLayoutById(String id)**

  Fetches a single layout by its ID.

  ```dart
  Future<Layout> layout = justCmsService.getLayoutById('footer');
  ```

- **getLayoutsByIds(List<String> ids)**

  Fetches multiple layouts at once by providing a list of IDs.

  ```dart
  Future<List<Layout>> layouts = justCmsService.getLayoutsByIds(['footer', 'header']);
  ```

### Utility Methods

In addition to API calls, `JustCMSService` provides several utility functions:

- **isBlockHasStyle(ContentBlock block, String style)**

  Checks if a content block has a specific style (case-insensitive).

- **getLargeImageVariant(CmsImage image)**

  Retrieves the large variant (typically the second variant) of an image, if available.

- **getFirstImage(ImageBlock block)**

  Retrieves the first image from an image block.

- **hasCategory(PageDetail page, String categorySlug)**

  Checks if a page belongs to a specific category.

## API Endpoints Overview

The service wraps the following JustCMS API endpoints:

- **Get Categories:** Retrieve all categories.
- **Get Pages:** Retrieve pages with optional filtering (by category slug) and pagination.
- **Get Page by Slug:** Retrieve detailed information about a specific page.
- **Get Menu by ID:** Retrieve a menu and its items.
- **Get Layout by ID:** Retrieve a single layout by its ID.
- **Get Layouts by IDs:** Retrieve multiple layouts at once by specifying their IDs.

For further details on each endpoint, refer to the [JustCMS Public API Documentation](https://justcms.co/api).

## Conclusion

This Flutter integration provides a clean, type-safe way to interact with the JustCMS API. Feel free to customize and extend the service and models to meet your project's requirements. Contributions, issues, and feature requests are always welcome!
