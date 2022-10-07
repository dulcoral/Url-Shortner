import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_shortner/domain/entities.dart/shorten_url.dart';
import 'package:url_shortner/presentation/url_viewmodel.dart';
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

  void getShortenUrl() async {
    if (originalUrl.isNotEmpty && Utils().isValidUrl(originalUrl)) {
      viewModel.createUrlAlias(originalUrl);
      setState(() {});
    } else {
      showSnackErrorBar();
    }
  }

  void resetForm() {
    originalUrl = '';
    controller.text = '';
  }

  void showSnackErrorBar() {
    const snackBar = SnackBar(
      content: Text('Please, enter a valid URL'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleShortenUrlResult() {
    final result =
        ref.watch(urlViewModelProvider.select((value) => value.result));
    result?.fold((l) => showSnackErrorBar(), ((r) => items.add(r)));
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
          padding: const EdgeInsets.all(20.0),
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
                                  hintText: "Enter an URL to shorter"),
                              keyboardType: TextInputType.url,
                              validator: (value) {
                                if (value == null ||
                                    !Utils().isValidUrl(value) && value != '') {
                                  return 'Invalidate Url';
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
              child: const Text('Clear form'),
            )),
        if (items.isNotEmpty)
          Text('Recently shortened URLs',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ListView.builder(
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.toSet().length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 7),
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      child: ListTile(
                          title: SelectableText(
                              items.toSet().toList()[index].short.toString()),
                          subtitle: SelectableText(
                              items.toSet().toList()[index].self.toString()))));
            })
      ]),
    );
  }
}
