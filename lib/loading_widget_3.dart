import 'package:flutter/material.dart';
import 'package:fluttersamplecounter/top_page_3.dart';
import 'package:provider/provider.dart';

class LoadingWidget3 extends StatelessWidget {
  const LoadingWidget3();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LoadingBloc>(context);
    return StreamBuilder<bool>(
      initialData: false,
      stream: bloc.value,
      builder: (context, snapshot) {
        return snapshot.data
            ? const DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0x44000000),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox.shrink();
      },
    );
  }
}
