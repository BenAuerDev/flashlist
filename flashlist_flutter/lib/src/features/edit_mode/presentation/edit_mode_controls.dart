import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flashlist_client/flashlist_client.dart';
import 'package:flashlist_flutter/src/constants/app_sizes.dart';
import 'package:flashlist_flutter/src/features/color_picker/application/color_picker_controller.dart';
import 'package:flashlist_flutter/src/features/edit_mode/application/edit_mode_controller.dart';
import 'package:flashlist_flutter/src/features/edit_mode/application/edit_mode_panel_controller.dart';
import 'package:flashlist_flutter/src/features/flashlist/application/flashlist_controller.dart';
import 'package:flashlist_flutter/src/utils/local_storage/local_storage_helper.dart';

/// Controls buttons for Edit Mode Panel
/// Confirm and Cancel
/// Confirm will save the changes
/// Cancel will discard the changes
class EditModeControls extends ConsumerWidget {
  const EditModeControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editModeController = ref.watch(editModeControllerProvider);
    final editModePanel = ref.watch(editModePanelControllerProvider);

    final textEditingController =
        ref.watch(flashlistTitleInputControllerProvider);

    final colorPicker = ref.watch(colorPickerControllerProvider);

    final flashlistController = ref.watch(flashlistControllerProvider);

    void onConfirm() {
      final colorStringValue = colorPicker.color.toColor().value.toString();

      flashlistController.updateFlashlist(
        UpdateFlashlist(
          id: editModePanel.flashlistInEditMode,
          title: textEditingController.text,
          color: colorStringValue,
        ),
      );

      ref.read(localStorageHelperProvider.notifier).addColor(colorStringValue);

      editModeController.toggleEditMode(null);
      FocusScope.of(context).unfocus();
    }

    void onCancel() {
      editModeController.toggleEditMode(null);
    }

    print(IconTheme.of(context).color);

    return Row(
      children: [
        // Confirm
        SizedBox(
          width: Sizes.p40,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: onConfirm,
            child: const Icon(
              Icons.check,
              color: Color(0xdd000000),
            ),
          ),
        ),
        gapW4,
        // Cancel
        SizedBox(
          width: Sizes.p40,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: onCancel,
            child: const Icon(
              Icons.close,
              color: Color(0xdd000000),
            ),
          ),
        ),
      ],
    );
  }
}
