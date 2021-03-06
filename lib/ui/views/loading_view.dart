import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flare_loading/flare_loading.dart';
import 'package:provider/provider.dart';

import '../../core/models/tvshow_details.dart';
import '../../core/models/tvshow_result.dart';
import '../../core/utils/constants.dart';
import '../../core/viewmodels/views/loading_view_model.dart';
import '../base_widget.dart';
import '../shared/styles.dart';
import '../shared/unicons_icons.dart';
import 'result_view.dart';
import 'tab_view.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key key, this.tvshowDetails}) : super(key: key);
  final TvshowDetails tvshowDetails;

  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoadingViewModel>(
        model: LoadingViewModel(
          randomService: Provider.of(context),
        ),
        onModelReady: (LoadingViewModel model) {
          model
              .sortRandomEpisode(
            widget.tvshowDetails,
            FlutterI18n.currentLocale(context).languageCode.toString(),
          )
              .then(
            (TvshowResult tvshowResult) {
              if (tvshowResult != null) {
                Navigator.pushNamedAndRemoveUntil<ResultView>(
                  context,
                  RoutePaths.RESULT,
                  ModalRoute.withName(RoutePaths.TAB),
                  arguments: tvshowResult,
                );
              } else {
                Flushbar<Object>(
                  message: FlutterI18n.translate(
                      context, 'app.loading.general_error'),
                  backgroundColor: StyleColor.PRIMARY,
                  flushbarPosition: FlushbarPosition.TOP,
                  flushbarStyle: FlushbarStyle.GROUNDED,
                  isDismissible: true,
                )..show(context);
                // Flushbar<Object>(
                //   message: FlutterI18n.translate(
                //       context, 'app.loading.connection_error'),
                //   backgroundColor: StyleColor.PRIMARY,
                //   flushbarPosition: FlushbarPosition.TOP,
                //   flushbarStyle: FlushbarStyle.GROUNDED,
                //   isDismissible: false,
                // )..show(context);

              }
            },
          );
        },
        builder: (BuildContext context, LoadingViewModel model, Widget child) {
          return Scaffold(
            body: SafeArea(
                child: Padding(
              padding: DEFAULT_INSESTS,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      FlutterI18n.translate(context, 'app.loading.title'),
                      style: StyleText.MESSAGES,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: FlareLoading(
                      name: Images.LOADING,
                      startAnimation: 'Loading',
                      loopAnimation: 'Loading',
                      onSuccess: (dynamic _) {},
                      onError: (dynamic err, dynamic stack) {},
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: FlatButton.icon(
                      label: Text(FlutterI18n.translate(
                          context, 'app.loading.button_home')),
                      icon: const Icon(Unicons.favorite),
                      onPressed: () =>
                          Navigator.pushNamedAndRemoveUntil<TabView>(
                        context,
                        RoutePaths.TAB,
                        ModalRoute.withName(RoutePaths.TAB),
                      ),
                    ),
                  )
                ],
              ),
            )),
          );
        });
  }
}
