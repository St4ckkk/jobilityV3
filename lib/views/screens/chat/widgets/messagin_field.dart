import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobility/controllers/agents_provider.dart';
import 'package:jobility/views/common/exports.dart';
import 'package:provider/provider.dart';

class MessagingField extends StatelessWidget {
  const MessagingField(
      {super.key,
      required TextEditingController messageController,
      required FocusNode messageFocusNode,
      this.ontap,
      this.sendText})
      : _messageController = messageController,
        _messageFocusNode = messageFocusNode;

  final TextEditingController _messageController;
  final FocusNode _messageFocusNode;
  final void Function()? ontap;
  final void Function()? sendText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.w),
        topRight: Radius.circular(20.w),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        width: width,
        height: 80.w,
        color: Colors.white,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 1,
          controller: _messageController,
          autofocus: false,
          focusNode: _messageFocusNode,
          onTap: ontap,
          style: appStyle(12, Colors.black, FontWeight.normal),
          decoration: InputDecoration(
              suffixIcon: SizedBox(
                width: 60.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        EvilIcons.image,
                        size: 30.w,
                      ),
                    ),
                    Consumer<AgentNotifier>(
                      builder: (context, agentNotifier, child) {
                        return GestureDetector(
                          onTap: sendText,
                          child: Icon(
                            MaterialCommunityIcons.send,
                            color: Color(kNewBlue.value),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              hintText: "send message ...",
              hintStyle: appStyle(12, Color(kDarkGrey.value), FontWeight.normal),
              enabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }
}
