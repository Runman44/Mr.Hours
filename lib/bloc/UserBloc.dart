import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/resource/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class LoadUser extends UserEvent {
  const LoadUser();
}

class UserBloc extends Bloc<UserEvent, UserState> {

  @override
  UserState get initialState {
    return UserLoadInProgress();
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is LoadUser) {
        print("userDto start");
        UserDto userDto = await getUserDetails();
        print("userDto end");
        yield UserLoadSuccess(User.fromDto(userDto));
    }
  }
}

abstract class UserState {
  const UserState();
}

class UserLoadInProgress extends UserState {}

class UserLoadSuccess extends UserState {
  final User user;

  UserLoadSuccess(this.user) : assert(user != null);
}