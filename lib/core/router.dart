import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_layout.dart';
import '../features/dashboard/presentation/home_screen.dart';
// import '../features/map/presentation/map_screen.dart';
import '../features/landing/presentation/landing_screen.dart';

import '../features/analysis/presentation/analysis_wizard_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/visits/presentation/check_in_screen.dart';
import '../features/visits/presentation/visit_dashboard_screen.dart';
import '../features/visits/presentation/visit_detail_screen.dart';

import '../features/visits/presentation/check_out_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';

import '../features/ndvi/presentation/ndvi_history_screen.dart';
import '../features/weather/presentation/weather_screen.dart';
import '../features/harvests/presentation/harvest_list_screen.dart';
import '../features/harvests/presentation/harvest_form_screen.dart';
import '../features/integrations/presentation/integrations_screen.dart';
import '../features/support/presentation/support_home_screen.dart';
import '../features/support/presentation/chat_screen.dart';
import '../features/support/presentation/create_ticket_screen.dart';
import '../features/support/domain/ticket_model.dart';

import '../features/scanner/presentation/scanner_screen.dart';
import '../features/occurrences/presentation/occurrence_list_screen.dart';
import '../features/occurrences/presentation/occurrence_detail_screen.dart';
import '../features/occurrences/presentation/new_occurrence_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/reports/presentation/visit_report_screen.dart';
import '../features/clients/presentation/client_list_screen.dart';
import '../features/clients/presentation/screens/client_detail_screen.dart';
import '../features/clients/presentation/screens/client_form_screen.dart';
import '../features/agenda/presentation/agenda_screen.dart';
import 'package:soloforte_app/features/occurrences/domain/entities/occurrence.dart';
import 'package:soloforte_app/features/agenda/presentation/event_detail_screen.dart';

import 'package:soloforte_app/features/agenda/presentation/event_form_screen.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
// import 'package:latlong2/latlong.dart';

import '../features/settings/presentation/settings_screen.dart';
import '../features/feedback/presentation/feedback_screen.dart';
import 'package:soloforte_app/features/scanner/presentation/scan_result_screen.dart';
import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';
import 'package:soloforte_app/features/marketing/presentation/marketing_screen.dart';
import 'package:soloforte_app/features/scanner/presentation/scan_history_screen.dart';
import 'package:soloforte_app/features/scanner/presentation/pest_library_screen.dart';
import 'package:soloforte_app/features/scanner/presentation/scanner_home_screen.dart';
import 'package:soloforte_app/features/reports/presentation/reports_list_screen.dart';
import 'package:soloforte_app/features/reports/presentation/new_report_screen.dart';
import 'package:soloforte_app/features/reports/presentation/report_detail_screen.dart';
import 'package:soloforte_app/features/visits/presentation/active_visit_screen.dart';
import '../features/link_hub/presentation/link_hub_screen.dart';
import '../features/privacy/presentation/privacy_policy_screen.dart';

// Keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Router Provider with Auth Guards
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      // Loading state
      if (authState.isLoading) {
        return null; // Show loading or splash
      }

      final isAuthenticated = authState.value != null;
      final currentPath = state.uri.path;

      // Public routes
      final publicRoutes = ['/', '/login', '/register', '/forgot-password'];
      final isPublicRoute = publicRoutes.contains(currentPath);

      // Redirect logic
      if (!isAuthenticated && !isPublicRoute) {
        // Not logged in, trying to access protected route
        return '/login';
      }

      if (isAuthenticated && isPublicRoute) {
        // Logged in, redirect to map
        return '/map';
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      // Map Shell Route (formerly Dashboard)
      ShellRoute(
        builder: (context, state, child) {
          return DashboardLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/map',
            builder: (context, state) => const HomeScreen(),
          ),
          // Sub-routes for /map
          GoRoute(
            path: '/map/occurrences',
            builder: (context, state) => const OccurrenceListScreen(),
          ),
          GoRoute(
            path: '/map/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/map/clients',
            builder: (context, state) => const ClientListScreen(),
          ),
          GoRoute(
            path: '/map/calendar',
            builder: (context, state) => const AgendaScreen(),
          ),
          GoRoute(
            path: '/map/ndvi',
            builder: (context, state) => const NDVIHistoryScreen(),
          ),
          GoRoute(
            path: '/map/weather',
            builder: (context, state) => const WeatherScreen(),
          ),
          GoRoute(
            path: '/map/harvest',
            builder: (context, state) => const HarvestListScreen(),
          ),
          GoRoute(
            path: '/map/integrations',
            builder: (context, state) => const IntegrationsScreen(),
          ),
          GoRoute(
            path: '/map/marketing',
            builder: (context, state) => const MarketingScreen(),
          ),
          GoRoute(
            path: '/map/support',
            builder: (context, state) => const SupportHomeScreen(),
          ),
          GoRoute(
            path: '/map/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/map/feedback',
            builder: (context, state) => const FeedbackScreen(),
          ),
          GoRoute(
            path: '/map/link-hub',
            builder: (context, state) => const LinkHubScreen(),
          ),
        ],
      ),
      // Full screen routes (outside ShellRoute)
      GoRoute(
        path: '/map/harvest/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HarvestFormScreen(),
      ),
      GoRoute(
        path: '/map/support/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateTicketScreen(),
      ),
      GoRoute(
        path: '/map/support/chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final ticket = state.extra as Ticket?;
          return ChatScreen(ticket: ticket);
        },
      ),
      GoRoute(
        path: '/map/scanner',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScannerHomeScreen(),
      ),
      GoRoute(
        path: '/map/scanner/camera',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/map/scanner/results',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return ScanResultsScreen(
            imagePath: args['imagePath'],
            result: args['result'] as ScanResult,
          );
        },
      ),
      GoRoute(
        path: '/map/scanner/history',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScanHistoryScreen(),
      ),
      GoRoute(
        path: '/map/scanner/library',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PestLibraryScreen(),
      ),
      GoRoute(
        path: '/check-in',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckInScreen(),
      ),

      // Reports Feature
      GoRoute(
        path: '/reports',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReportsListScreen(),
      ),
      GoRoute(
        path: '/reports/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NewReportScreen(),
      ),

      // Moved Routes (formerly nested in ShellRoute)
      GoRoute(
        path: '/occurrences/detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            OccurrenceDetailScreen(occurrenceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/occurrences/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          return NewOccurrenceScreen(
            initialTitle: extras?['title'],
            initialDescription: extras?['description'],
            initialType: extras?['type'],
            initialImagePath: extras?['imagePath'],
            initialSeverity: extras?['severity'],
            initialLatitude: extras?['latitude'],
            initialLongitude: extras?['longitude'],
          );
        },
      ),
      GoRoute(
        path: '/occurrences/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final occurrence = state.extra as Occurrence?;
          return NewOccurrenceScreen(initialOccurrence: occurrence);
        },
      ),
      // Clients
      GoRoute(
        path: '/map/clients/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ClientFormScreen(),
      ),
      GoRoute(
        path: '/map/clients/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            ClientDetailScreen(clientId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'edit',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) =>
                ClientFormScreen(clientId: state.pathParameters['id']),
          ),
        ],
      ),
      // Calendar
      GoRoute(
        path: '/map/calendar/detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final event = state.extra as Event;
          return EventDetailScreen(event: event);
        },
      ),
      GoRoute(
        path: '/map/calendar/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final initialDate = state.extra as DateTime?;
          return EventFormScreen(initialDate: initialDate);
        },
      ),
      // Reports
      GoRoute(
        path: '/map/report/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VisitReportScreen(),
      ),

      // Team
      GoRoute(
        path: '/reports/detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return ReportDetailScreen(reportId: state.pathParameters['id']!);
        },
      ),
      GoRoute(
        path: '/visit/active',
        builder: (context, state) => const ActiveVisitScreen(),
      ),
      GoRoute(
        path: '/visit/dashboard',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VisitDashboardScreen(),
      ),
      GoRoute(
        path: '/visit/checkout',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CheckOutScreen(),
      ),
      GoRoute(
        path: '/analysis/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AnalysisWizardScreen(),
      ),
      GoRoute(
        path: '/visit/detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return VisitDetailScreen(visitId: state.pathParameters['id']!);
        },
      ),
    ],
  );
});
