flutter_access_gates

Декларативный слой управления доступом для Flutter UI.

Позволяет условно отображать виджеты в зависимости от:
	•	ролей пользователя (RoleGate)
	•	разрешений (PermissionGate)
	•	feature-флагов (FeatureGate)
	•	пользовательских условий (GateUiBuilder, CompositeGate)

Работает по паттерну Access Strategy, поддерживает внедрение своей логики и моков для тестов.

🚀 Установка

Добавьте в pubspec.yaml:

dependencies:
  flutter_access_gates:
    git:
      url: https://github.com/Ocengrave/flutter_access_gates.git

✨ Пример использования

FeatureGate(
  flag: 'new_ui',
  child: NewUIWidget(),
  fallback: OldUIWidget(),
)

PermissionGate(
  permission: 'edit_profile',
  child: ElevatedButton(...),
)

CompositeAccessGate(
  conditions: [
    (ctx) => ctx.read<Session>().isAdmin,
    (ctx) => DateTime.now().isBefore(DateTime(2025)),
  ],
  child: Banner(...),
)

🧱 Компоненты

Виджет	Назначение
RoleGate	Проверка наличия роли у пользователя
PermissionGate	Проверка наличия права/разрешения
FeatureGate	Проверка включённости фичи через FeatureFlags
CompositeAccessGate	Проверка нескольких условий сразу (AND)
GateUiBuilder	Свободная логика доступа, как builder
DebugGate	Отображение только в debug-сборках

🧠 AccessStrategy

Все гейты используют стратегию доступа — реализацию интерфейса AccessStrategy, которую можно внедрить через AccessStrategyProvider.

AccessStrategyProvider(
  strategy: MyAccessStrategy(),
  child: MyApp(),
)

Пример собственной стратегии:

class FakeAccessStrategy implements AccessStrategy {
  @override
  bool hasPermission(BuildContext ctx, String permission) => true;
  @override
  bool hasRole(BuildContext ctx, String role) => role == 'admin';
  @override
  bool isFeatureEnabled(BuildContext ctx, String flag) => false;
}

🧪 Покрытие тестами

Каждый гейт покрыт unit-тестами. Вы можете использовать FakeAccessStrategy или MockAccessStrategy для своих тестов.

📦 Пример приложения

cd example
flutter run

📋 To-do / Roadmap
	•	Базовые гейты: Role, Permission, Feature
	•	Composite и кастомный builder
	•	Поддержка стратегии доступа через Provider
	•	Покрытие тестами
	•	Локализация сообщений отказа
	•	Виджеты “если нет доступа” (например, DisabledButtonIfDenied)

🧾 License

MIT

⸻

Made with ❤️ by @Ocengrave