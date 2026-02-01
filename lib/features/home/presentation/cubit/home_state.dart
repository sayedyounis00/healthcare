import 'package:equatable/equatable.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/getUserInfo/data/models/patient_model.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final PatientModel? patient;
  final List<MedicineModel> medicines;
  final List<AppointmentModel> appointments;
  final MedicineModel? nextMedicine;
  final AppointmentModel? nextAppointment;
  final int medicineCount;
  final int appointmentCount;
  final String greeting;

  const HomeLoaded({
    this.patient,
    this.medicines = const [],
    this.appointments = const [],
    this.nextMedicine,
    this.nextAppointment,
    this.medicineCount = 0,
    this.appointmentCount = 0,
    this.greeting = 'Hello',
  });

  HomeLoaded copyWith({
    PatientModel? patient,
    List<MedicineModel>? medicines,
    List<AppointmentModel>? appointments,
    MedicineModel? nextMedicine,
    AppointmentModel? nextAppointment,
    int? medicineCount,
    int? appointmentCount,
    String? greeting,
  }) {
    return HomeLoaded(
      patient: patient ?? this.patient,
      medicines: medicines ?? this.medicines,
      appointments: appointments ?? this.appointments,
      nextMedicine: nextMedicine ?? this.nextMedicine,
      nextAppointment: nextAppointment ?? this.nextAppointment,
      medicineCount: medicineCount ?? this.medicineCount,
      appointmentCount: appointmentCount ?? this.appointmentCount,
      greeting: greeting ?? this.greeting,
    );
  }

  @override
  List<Object?> get props => [
    patient,
    medicines,
    appointments,
    nextMedicine,
    nextAppointment,
    medicineCount,
    appointmentCount,
    greeting,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
