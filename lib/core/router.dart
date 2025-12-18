import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/auth_provider.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_layout.dart';
import '../features/dashboard/presentation/home_screen.dart';
import '../features/map/presentation/map_screen.dart';
import '../features/landing/presentation/landing_screen.dart';
import '../features/dashboard/presentation/executive_dashboard_screen.dart';

import '../features/team/presentation/team_list_screen.dart';
import '../features/team/presentation/team_member_detail_screen.dart';
import '../features/team/presentation/team_map_screen.dart';
import '../features/team/presentation/team_ranking_screen.dart';
import '../features/team/presentation/route_history_screen.dart';
import '../features/team/presentation/team_chat_list_screen.dart';
import '../features/team/presentation/team_chat_detail_screen.dart';
import '../features/team/presentation/time_clock_screen.dart';
import '../features/team/presentation/approvals_screen.dart';
import '../features/team/presentation/sos_screen.dart';

import '../features/analysis/presentation/analysis_wizard_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/visits/presentation/check_in_screen.dart';
import '../features/visits/presentation/visit_dashboard_screen.dart';
import '../features/visits/presentation/visit_detail_screen.dart';
import '../features/visits/domain/visit_model.dart';

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
import '../features/marketing/presentation/feed_screen.dart';
import '../features/scanner/presentation/scanner_screen.dart';
import '../features/occurrences/presentation/occurrence_list_screen.dart';
import '../features/occurrences/presentation/occurrence_detail_screen.dart';
import '../features/occurrences/presentation/new_occurrence_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/reports/presentation/visit_report_screen.dart';
import '../features/clients/presentation/screens/client_list_screen_enhanced.dart';
import '../features/clients/presentation/screens/client_detail_screen.dart';
import '../features/clients/presentation/screens/client_form_screen.dart';
import '../features/agenda/presentation/agenda_screen.dart';
import 'package:soloforte_app/features/occurrences/domain/occurrence_model.dart';
import 'package:soloforte_app/features/agenda/presentation/event_detail_screen.dart';

import 'package:soloforte_app/features/agenda/presentation/event_form_screen.dart';
import 'package:soloforte_app/features/agenda/domain/event_model.dart';
import 'package:latlong2/latlong.dart';

import '../features/settings/presentation/settings_screen.dart';
import 'package:soloforte_app/features/scanner/presentation/scan_result_screen.dart';
import 'package:soloforte_app/features/scanner/domain/scan_result_model.dart';
import 'package:soloforte_app/features/scanner/presentation/scan_history_screen.dart';
import 'package:soloforte_app/features/scanner/presentation/pest_library_screen.dart';
import 'package:soloforte_app/features/scanner/presentation/scanner_home_screen.dart';
import 'package:soloforte_app/features/reports/presentation/reports_list_screen.dart';
import 'package:soloforte_app/features/reports/presentation/new_report_screen.dart';
import 'package:soloforte_app/features/reports/presentation/report_detail_screen.dart';
import 'package:soloforte_app/features/visits/presentation/active_visit_screen.dart';

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

      if (isAuthenticated && isPublicRoute && currentPath != '/') {
        // Logged in, trying to access auth pages
        return '/dashboard';
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
      // Dashboard Shell Route
      ShellRoute(
        builder: (context, state, child) {
          return DashboardLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/dashboard/map',
            builder: (context, state) {
              final LatLng? location = state.extra as LatLng?;
              return MapScreen(initialLocation: location);
            },
          ),
          GoRoute(
            path: '/dashboard/occurrences',
            builder: (context, state) => const OccurrenceListScreen(),
          ),
          GoRoute(
            path: '/occurrences/detail/:id',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => OccurrenceDetailScreen(
              occurrenceId: state.pathParameters['id']!,
            ),
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
          GoRoute(
            path: '/dashboard/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/dashboard/clients',
            builder: (context, state) => const ClientListScreenEnhanced(),
            routes: [
              GoRoute(
                path: 'new',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ClientFormScreen(),
              ),
              GoRoute(
                path: ':id',
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
            ],
          ),
          GoRoute(
            path: '/dashboard/calendar',
            builder: (context, state) => const AgendaScreen(),
            routes: [
              GoRoute(
                path: 'detail',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final event = state.extra as Event;
                  return EventDetailScreen(event: event);
                },
              ),
              GoRoute(
                path: 'new',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final initialDate = state.extra as DateTime?;
                  return EventFormScreen(initialDate: initialDate);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/dashboard/ndvi',
            builder: (context, state) => const NDVIHistoryScreen(),
          ),
          GoRoute(
            path: '/dashboard/weather',
            builder: (context, state) => const WeatherScreen(),
          ),
          GoRoute(
            path: '/dashboard/harvest',
            builder: (context, state) => const HarvestListScreen(),
          ),
          GoRoute(
            path: '/dashboard/integrations',
            builder: (context, state) => const IntegrationsScreen(),
          ),
          GoRoute(
            path: '/dashboard/support',
            builder: (context, state) => const SupportHomeScreen(),
          ),
          GoRoute(
            path: '/dashboard/feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/dashboard/report/new',
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const VisitReportScreen(),
          ),
          GoRoute(
            path: '/dashboard/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/dashboard/executive',
            builder: (context, state) => const ExecutiveDashboardScreen(),
          ),
          GoRoute(
            path: '/dashboard/team',
            builder: (context, state) => const TeamListScreen(),
            routes: [
              GoRoute(
                path: 'map',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const TeamMapScreen(),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => TeamMemberDetailScreen(
                  memberId: state.pathParameters['id']!,
                ),
              ),
              GoRoute(
                path: 'ranking',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const TeamRankingScreen(),
              ),
              GoRoute(
                path: ':id/history',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final extras = state.extra as Map<String, dynamic>;
                  return RouteHistoryScreen(
                    memberId: state.pathParameters['id']!,
                    memberName: extras['name'],
                  );
                },
              ),
              GoRoute(
                path: 'chat',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const TeamChatListScreen(),
              ),
              GoRoute(
                path: 'chat/:chatId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final extras =
                      state.extra as Map<String, dynamic>? ?? {'title': 'Chat'};
                  return TeamChatDetailScreen(
                    conversationId: state.pathParameters['chatId']!,
                    title: extras['title'],
                  );
                },
              ),
              GoRoute(
                path: 'time-clock',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const TimeClockScreen(),
              ),
              GoRoute(
                path: 'approvals',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const ApprovalsScreen(),
              ),
              GoRoute(
                path: 'sos',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const SOSScreen(),
              ),
            ],
          ),
        ],
      ),
      // Full screen routes (outside ShellRoute)
      GoRoute(
        path: '/dashboard/harvest/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HarvestFormScreen(),
      ),
      GoRoute(
        path: '/dashboard/support/create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateTicketScreen(),
      ),
      GoRoute(
        path: '/dashboard/support/chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final ticket = state.extra as Ticket?;
          return ChatScreen(ticket: ticket);
        },
      ),
      GoRoute(
        path: '/dashboard/scanner',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScannerHomeScreen(),
      ),
      GoRoute(
        path: '/dashboard/scanner/camera',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScannerScreen(),
      ),
      GoRoute(
        path: '/dashboard/scanner/results',
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
        path: '/dashboard/scanner/history',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScanHistoryScreen(),
      ),
      GoRoute(
        path: '/dashboard/scanner/library',
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
      GoRoute(
        path: '/reports/detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final report = state.extra as MockReport;
          return ReportDetailScreen(report: report);
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
        path: '/visit/detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final visit = state.extra as Visit;
          return VisitDetailScreen(visit: visit);
        },
      ),
    ],
  );
});
