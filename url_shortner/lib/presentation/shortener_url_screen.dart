import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_shortner/constants/app_sizes.dart';
import 'package:url_shortner/constants/app_strings.dart';
import 'package:url_shortner/domain/entities.dart/shorten_url.dart';
import 'package:url_shortner/presentation/url_viewmodel.dart';
import 'package:url_shortner/styles/text_style.dart';
import 'package:url_shortner/utils/utils.dart';

class ShortenerUrlScreen extends ConsumerStatefulWidget {
  const ShortenerUrlScreen({super.key});

  @override
  ConsumerState<ShortenerUrlScreen> createState() => _ShortenerUrlScreenState();
}

class _ShortenerUrlScreenState extends ConsumerState<ShortenerUrlScreen> {
  late UrlViewModel viewModel;
  String text = "";
  List<ShortenUrl> items = List.empty(growable: true);
  final controller = TextEditingController();
  String originalUrl = '';

  @override
  void initState() {
    viewModel = ref.read(urlViewModelProvider);
    super.initState();
  }

  void getShortenUrl() {
    if (items.isNotEmpty && items.first.self == originalUrl) {
      showSnackErrorBar(AppStrings.existUrl);
    } else if (originalUrl.isNotEmpty && Utils().isValidUrl(originalUrl)) {
      viewModel.createUrlAlias(originalUrl);
    } else {
      showSnackErrorBar(AppStrings.errorSnackErrorUrl);
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void resetForm() {
    originalUrl = '';
    controller.text = '';
  }

  void showSnackErrorBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showCopiedSnackBar() {
    const snackBar = SnackBar(
      content: Text(AppStrings.copied),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleShortenUrlResult() {
    final result =
        ref.watch(urlViewModelProvider.select((value) => value.result));
    result?.fold((l) => showSnackErrorBar(l.message), ((r) => addItemUrl(r)));
  }

  void addItemUrl(ShortenUrl shortenUrl) {
    if (items.isEmpty ||
        !items.contains(shortenUrl) ||
        (items.contains(shortenUrl) && items.first != shortenUrl)) {
      items.insert(0, shortenUrl);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handleShortenUrlResult();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.size_20),
          child: Center(
              child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                          color: Colors.purple)),
                                  prefixIcon: const Icon(Icons.link,
                                      color: Colors.grey),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.paste),
                                    onPressed: () {
                                      FlutterClipboard.paste().then((value) {
                                        setState(() {
                                          controller.text = value;
                                          originalUrl = value;
                                        });
                                      });
                                    },
                                  ),
                                  hintText: AppStrings.hintTextInputUrl),
                              keyboardType: TextInputType.url,
                              validator: (value) {
                                if (value == null ||
                                    !Utils().isValidUrl(value) && value != '') {
                                  return AppStrings.errorTextInputUrl;
                                }
                                return null;
                              },
                              onChanged: (string) {
                                originalUrl = string.trim();
                              })),
                      IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: getShortenUrl),
                    ],
                  ))),
        ),
        Align(
            alignment: Alignment.center,
            child: OutlinedButton(
              onPressed: resetForm,
              child: const Text(AppStrings.clearUrlInput),
            )),
        if (items.isNotEmpty)
          const Text(AppStrings.recentlyUrls, style: AppTextStyle.titleStyle),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.size_12, horizontal: AppSizes.size_4),
                child: Card(
                    elevation: AppSizes.size_3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.size_5)),
                    child: ListTile(
                        title: SelectableText(items[index].short.toString(),
                            onTap: (() =>
                                FlutterClipboard.copy(items[index].short)
                                    .then((value) => showCopiedSnackBar()))),
                        subtitle:
                            SelectableText(items[index].self.toString()))),
              );
            })
      ]),
    );
  }
}
