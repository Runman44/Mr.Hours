import 'package:eventtracker/model/model.dart';
import 'package:eventtracker/resource/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UserEvent { geteverything }

class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserState get initialState => UserState.initial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event) {
      case UserEvent.geteverything:
        print("userDto start");
        UserDto userDto = await getUserDetails();
        print("userDto end");
        yield UserState(User.fromDto(userDto));
        break;
    }
  }
}

class UserState {
  final User user;

  UserState(this.user) : assert(user != null);

  static UserState initial() {
    return UserState(User());
  }
}
