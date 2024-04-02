import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flashlist_client/flashlist_client.dart';
import 'package:flashlist_flutter/src/constants/app_sizes.dart';
import 'package:flashlist_flutter/src/features/users/application/user_controller.dart';
import 'package:flashlist_flutter/src/features/users/presentation/connections/connection_request_input.dart';
import 'package:flashlist_flutter/src/features/users/presentation/connections/connection_request_row.dart';
import 'package:flashlist_flutter/src/features/users/presentation/user_avatar_row.dart';
import 'package:flashlist_flutter/src/shared/async_list_with_title.dart';
import 'package:flashlist_flutter/src/utils/context_helper.dart';

/// Screen for managing connections and requests.
/// [StatelessWidget] that holds the [ConnectionRequests] and the [ListRequestsWidget].
class ConnectionsScreen extends ConsumerWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(localizationsOf(context).connectionsAndRequests)),
        actions: const [
          SizedBox(
            width: Sizes.p20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          child: Column(
            children: [
              gapH20, const ConnectionRequestInput(),
              gapH16,
              // * Pending requests to connect
              AsyncValueListWithTitle(
                title: localizationsOf(context).pendingConnectionRequests,
                value: ref.watch(pendingRequestsProvider('connection')),
                listItemBuilder: (UserRequest? request) {
                  return ConnectionRequestRow(request!);
                },
              ),
              gapH20,
              // * List of connections
              AsyncValueListWithTitle(
                title: localizationsOf(context).connections,
                value: ref.watch(connectionsProvider),
                listItemBuilder: (AppUser? connection) {
                  return UserAvatarRow(username: connection!.username);
                },
              ),
              gapH20,
              // * Pending requests to join a list
              // TODO: think about a nice way to display list invites
              // What info should be displayed?
              AsyncValueListWithTitle(
                title: localizationsOf(context).pendingFlashlistRequests,
                value: ref.watch(pendingRequestsProvider('join_flashlist')),
                listItemBuilder: (UserRequest? request) {
                  return request != null
                      ? ConnectionRequestRow(request)
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}