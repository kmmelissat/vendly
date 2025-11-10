import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc gestiona el estado de autenticación de la aplicación usando el patrón BLoC.
///
/// Este bloc maneja todos los eventos relacionados con autenticación (login, registro, logout) y
/// emite estados correspondientes a los que la UI puede reaccionar. Actúa como intermediario entre
/// la capa de UI y el AuthService, gestionando la lógica de negocio y las transiciones de estado.
///
/// El patrón BLoC separa la lógica de negocio de la UI, haciendo el código más testeable
/// y mantenible. Los eventos fluyen hacia adentro (acciones del usuario), y los estados fluyen hacia afuera (actualizaciones de UI).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  /// El constructor inicializa el bloc con una dependencia de AuthService y establece
  /// el estado inicial como AuthInitial.
  ///
  /// Los manejadores de eventos se registran aquí usando el método `on<EventType>`,
  /// que mapea cada tipo de evento a su función manejadora correspondiente.
  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(AuthInitial()) {
    // Registrar manejadores de eventos para cada evento de autenticación
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
  }

  /// Maneja el evento LoginRequested (Solicitud de Inicio de Sesión).
  ///
  /// Flujo:
  /// 1. Emite el estado AuthLoading para mostrar el indicador de carga en la UI
  /// 2. Llama al AuthService para realizar la llamada API de login
  /// 3. Si es exitoso, extrae los datos del usuario y el token de la respuesta
  /// 4. Emite el estado AuthSuccess con la información del usuario
  /// 5. Si falla, emite el estado AuthFailure con el mensaje de error
  ///
  /// La UI escucha estos cambios de estado y se actualiza en consecuencia
  /// (por ejemplo, muestra un spinner de carga, navega al home, o muestra un error).
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Emitir estado de carga para mostrar indicador de progreso en la UI
    emit(AuthLoading());
    try {
      // Llamar al servicio de autenticación para realizar el login
      final result = await _authService.login(
        email: event.email,
        password: event.password,
      );

      // Verificar si el login fue exitoso
      if (result['success'] == true) {
        // Extraer datos del usuario de la respuesta
        final user = result['user'] as Map<String, dynamic>? ?? {};

        // Emitir estado de éxito con información del usuario y token de autenticación
        emit(
          AuthSuccess(
            token: result['token'] ?? '',
            userId: user['id']?.toString(),
            name: user['name']?.toString() ?? user['username']?.toString(),
            email: user['email']?.toString() ?? user['username']?.toString(),
          ),
        );
      } else {
        // Login falló, emitir estado de fallo con mensaje de error
        emit(AuthFailure(error: result['message'] ?? 'Login failed'));
      }
    } catch (e) {
      // Manejar cualquier excepción (errores de red, errores de parsing, etc.)
      emit(AuthFailure(error: e.toString()));
    }
  }

  /// Maneja el evento RegisterRequested (Solicitud de Registro).
  ///
  /// Similar al login, pero incluye información adicional de la tienda requerida
  /// para el registro de nuevos usuarios. Esto es específico del modelo de negocio donde
  /// los usuarios se registran con los detalles de su tienda.
  ///
  /// Flujo:
  /// 1. Emite el estado AuthLoading
  /// 2. Llama a AuthService.register() con información del usuario y la tienda
  /// 3. En caso de éxito, emite AuthSuccess con el token y datos del usuario
  /// 4. En caso de fallo, emite AuthFailure con mensaje de error
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Emitir estado de carga
    emit(AuthLoading());
    try {
      // Llamar al servicio de autenticación para registrar nuevo usuario
      final result = await _authService.register(
        name: event.name,
        email: event.email,
        password: event.password,
        storeName: event.storeName,
        storeLocation: event.storeLocation,
        storeType: event.storeType,
        phone: event.phone,
      );

      // Verificar si el registro fue exitoso
      if (result['success'] == true) {
        // Extraer datos del usuario de la respuesta
        final user = result['user'] as Map<String, dynamic>? ?? {};

        // Emitir estado de éxito - el usuario ahora está autenticado
        emit(
          AuthSuccess(
            token: result['token'] ?? '',
            userId: user['id']?.toString(),
            name: user['name']?.toString() ?? user['username']?.toString(),
            email: user['email']?.toString() ?? user['username']?.toString(),
          ),
        );
      } else {
        // Registro falló, emitir estado de fallo
        emit(AuthFailure(error: result['message'] ?? 'Registration failed'));
      }
    } catch (e) {
      // Manejar cualquier excepción durante el registro
      emit(AuthFailure(error: e.toString()));
    }
  }

  /// Maneja el evento LogoutRequested (Solicitud de Cierre de Sesión).
  ///
  /// Limpia la sesión de autenticación del usuario y lo devuelve al
  /// estado no autenticado. Esto típicamente involucra limpiar los tokens almacenados
  /// y los datos de sesión.
  ///
  /// Flujo:
  /// 1. Llama a AuthService.logout() para limpiar los datos de sesión
  /// 2. Emite el estado AuthUnauthenticated
  /// 3. En caso de error, emite AuthFailure (aunque el logout rara vez falla)
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Limpiar tokens de autenticación y datos de sesión
      await _authService.logout();

      // Emitir estado no autenticado - la UI navegará a la pantalla de login
      emit(AuthUnauthenticated());
    } catch (e) {
      // Manejar cualquier error durante el logout
      emit(AuthFailure(error: e.toString()));
    }
  }

  /// Maneja el evento AuthStatusChanged (Cambio de Estado de Autenticación).
  ///
  /// Este evento típicamente se dispara cuando la app inicia o cuando el
  /// estado de autenticación cambia externamente (por ejemplo, el token expira, el usuario
  /// inicia sesión desde otro dispositivo, etc.).
  ///
  /// Verifica si hay un token válido almacenado y actualiza el estado en consecuencia.
  /// Esto permite que la app restaure la sesión del usuario al reiniciar la app.
  ///
  /// Flujo:
  /// 1. Verifica si el usuario está autenticado y tiene un token válido
  /// 2. Si es así, emite AuthSuccess para restaurar la sesión
  /// 3. Si no, emite AuthUnauthenticated para mostrar la pantalla de login
  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    if (event.isAuthenticated && event.token != null) {
      // El usuario tiene un token válido - restaurar su sesión autenticada
      // Nota: En una app de producción, podrías querer validar el token
      // con el servidor o obtener datos frescos del usuario aquí
      emit(AuthSuccess(token: event.token!));
    } else {
      // No se encontró un token válido - el usuario necesita iniciar sesión
      emit(AuthUnauthenticated());
    }
  }
}
