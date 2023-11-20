import 'package:faker_api_test/data/response/persons_responses.dart';
import 'package:faker_api_test/repositories/persons_respository/persons_repository.dart';
import 'package:get_it/get_it.dart';

abstract class GetPersonsUseCaseInterface {
  Future<PersonResponse?> getPersons({required int numberOfItems});
}

class GetPersonUseCase implements GetPersonsUseCaseInterface {
  PersonRepositoryInterface personRepository = GetIt.instance<PersonRepositoryInterface>();

  @override
  Future<PersonResponse?> getPersons({required int numberOfItems}) {
    return personRepository.getPersons(numberOfItems: numberOfItems);
  }
}
