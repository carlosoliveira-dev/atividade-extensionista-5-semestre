import '../repositories/google_calendar_repository.dart';

class ConsultarHorariosLivresUseCase {
  final GoogleCalendarRepository calendarRepository;

  ConsultarHorariosLivresUseCase(this.calendarRepository);

  Future<List<DateTime>> execute(DateTime data) async {
    return await calendarRepository.obterHorariosLivres(data);
  }
}
