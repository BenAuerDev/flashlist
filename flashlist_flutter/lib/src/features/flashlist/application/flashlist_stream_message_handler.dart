import 'package:flashlist_client/flashlist_client.dart';
import 'package:flashlist_flutter/src/utils/serverpod/serverpod_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Function returning a List object from [streamItems] corresponding
/// with the passed flashlistId
Flashlist? getFlashlistByFromStream(
  List<Flashlist?> streamItems,
  int flashlistId,
) {
  return streamItems.firstWhere((streamItem) => streamItem!.id == flashlistId);
}

/// Function returning the index of a Flashlist within [streamItems]
int? getFlashlistIndex(
  List<Flashlist?> streamItems,
  int flashlistId,
) {
  return streamItems.indexWhere((streamItem) => streamItem!.id == flashlistId);
}

/// Function to update the orderNr of siblings of a [FlashlistItem]
/// within a [List] of [FlashlistItem]s.
void updateOrderNrForSiblings(
  List<FlashlistItem?> listItems,
  FlashlistItem item,
  int? newOrderNr,
) {
  if (newOrderNr == null) {
    // Item is being deleted, reduce orderNr for all siblings coming after
    for (var currentItem in listItems) {
      if (currentItem!.orderNr > item.orderNr) {
        currentItem.orderNr = currentItem.orderNr - 1;
      }
    }
  } else {
    // Item is being moved
    int oldOrderNr = item.orderNr;
    for (var currentItem in listItems) {
      if (currentItem!.id != item.id) {
        if (oldOrderNr < newOrderNr &&
            currentItem.orderNr > oldOrderNr &&
            currentItem.orderNr <= newOrderNr) {
          // Item is moving down the list, decrease the orderNr of every following item by 1
          currentItem.orderNr = currentItem.orderNr - 1;
        } else if (oldOrderNr > newOrderNr &&
            currentItem.orderNr < oldOrderNr &&
            currentItem.orderNr >= newOrderNr) {
          // Item is moving up the list, increase the orderNr of every preceding item by 1
          currentItem.orderNr = currentItem.orderNr + 1;
        }
      }
    }
    // Finally, update the orderNr of the moved item
    item.orderNr = newOrderNr;
  }
  listItems.sort((a, b) => a!.orderNr.compareTo(b!.orderNr));
}

/// A function to handle the stream of flashlist messages
/// accepts a nullable [list] of flashlists and a [message]
/// that extends [SerializableEntity].
///
/// It will check for the type of the [message] and manipulate
/// the list [streamItems] accordingly.
void handleFlashlistStreamMessage(
  Ref ref,
  List<Flashlist?> streamItems,
  SerializableEntity message,
) {
  /// [FlashlistBatch] is a message that contains a collection of [Flashlist]
  /// entities. It is sent when the user first connects to the WebSocket.
  if (message is FlashlistBatch) {
    streamItems.addAll(message.collection);
  }

  /// [Flashlist] is a message that contains a single [Flashlist] entity.
  if (message is Flashlist) {
    streamItems.add(message);
  }

  /// [DeleteFlashlist] is a message that contains the [id] of a [Flashlist]
  /// entity that should be removed from the list.
  if (message is DeleteFlashlist) {
    streamItems.removeWhere((element) => element!.id == message.flashlistId);
  }

  /// [UpdateFlashlist] is a message that contains the [id] of a [Flashlist]
  /// entity that should be updated. It also contains the new [title] and [color]
  /// of the [Flashlist].
  if (message is UpdateFlashlist) {
    final indexToRemove =
        streamItems.indexWhere((element) => element!.id == message.id);
    final itemToRemove = streamItems[indexToRemove];

    streamItems.removeAt(indexToRemove);
    streamItems.insert(
      indexToRemove,
      itemToRemove!.copyWith(
        title: message.title,
        color: message.color,
      ),
    );
  }

  /// FlashlistItem is a message that contains a single [FlashlistItem] entity.
  if (message is FlashlistItem) {
    final flashlistToUpdate =
        getFlashlistByFromStream(streamItems, message.parentId);

    if (flashlistToUpdate!.items == null) {
      flashlistToUpdate.items = <FlashlistItem>[message];
    } else {
      flashlistToUpdate.items!.add(message);
    }
  }

  /// [UpdateFlashlistItem] is a message that contains the [id] of a [FlashlistItem]
  /// entity that should be updated. It also contains the new [title] and [color]
  /// of the [FlashlistItem].
  if (message is DeleteFlashlistItem) {
    final flashListToUpdate =
        getFlashlistByFromStream(streamItems, message.parentId);

    final itemToUpdate = flashListToUpdate!.items!
        .firstWhere((currentItem) => currentItem!.id == message.id);

    flashListToUpdate.items!
        .removeWhere((currentItem) => currentItem!.id == message.id);

    updateOrderNrForSiblings(flashListToUpdate.items!, itemToUpdate!, null);
  }

  /// [ReOrderFlashlistItem] is a message that contains the [id] of a [FlashlistItem]
  /// entity that should be updated. It also contains the new [orderNr] of the [FlashlistItem].
  if (message is ReOrderFlashlistItem) {
    final flashlistToUpdate =
        getFlashlistByFromStream(streamItems, message.parentId);

    final itemToUpdate = flashlistToUpdate!.items!
        .firstWhere((currentItem) => currentItem!.id == message.id);

    final newOrderNr = message.newOrderNr;

    flashlistToUpdate.items!
        .removeWhere((currentItem) => currentItem!.id == message.id);

    flashlistToUpdate.items!.insert(newOrderNr! - 1, itemToUpdate);

    updateOrderNrForSiblings(
      flashlistToUpdate.items!,
      itemToUpdate!,
      newOrderNr,
    );
  }

  if (message is AddUserToFlashlist) {
    final flashlistToUpdate =
        getFlashlistByFromStream(streamItems, message.flashlistId);

    if (flashlistToUpdate!.authors == null) {
      flashlistToUpdate.authors = <AppUser>[message.user];
    } else {
      flashlistToUpdate.authors!.add(message.user);
    }
  }

  if (message is JoinFlashlist) {
    final client = ref.read(clientProvider);
    client.flashlist.sendStreamMessage(message);
  }

  if (message is RemoveUserFromFlashlist) {
    final flashlistToUpdate =
        getFlashlistByFromStream(streamItems, message.flashlistId);

    flashlistToUpdate!.authors!
        .removeWhere((currentAuthor) => currentAuthor!.id == message.userId);
  }
}
