import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment(const [
      SiteHeader(),
      PortfolioMain(),
      SiteFooter(),
    ]);
  }
}

class SiteHeader extends StatelessComponent {
  const SiteHeader({super.key});

  @override
  Component build(BuildContext context) {
    return header(
      [
        div(
          [
            a(
              [
                span(
                  [Component.text('Flutter | Dart | Full-Stack')],
                  classes: 'brand-role',
                ),
              ],
              href: '#top',
              classes: 'brand',
            ),
            nav(
              [
                a([Component.text('Sobre mí')], href: '#about'),
                a([Component.text('Proyectos')], href: '#projects'),
                a([Component.text('Habilidades')], href: '#skills'),
                a([Component.text('Contacto')], href: '#contact'),
              ],
              classes: 'site-nav',
              attributes: const {'aria-label': 'Navegación principal'},
            ),
          ],
          classes: 'container header-inner',
        ),
      ],
      id: 'top',
      classes: 'site-header',
    );
  }
}

class PortfolioMain extends StatelessComponent {
  const PortfolioMain({super.key});

  @override
  Component build(BuildContext context) {
    return main_(
      const [
        HeroSection(),
        AboutSection(),
        ExperienceSection(),
        ProjectsSection(),
        SkillsSection(),
        EducationSection(),
        ContactSection(),
      ],
    );
  }
}

class HeroSection extends StatelessComponent {
  const HeroSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      [
        div(
          [
            div(
              [
                p(
                  [Component.text('SSR+ Full-Stack Flutter Developer')],
                  classes: 'hero-kicker',
                ),
                h1(
                  [Component.text('Nicolas Estigarribia')],
                  id: 'hero-title',
                  classes: 'hero-title gradient-text',
                ),
                p(
                  [Component.text('Arquitectura de Software · Mobile & Web · DevOps · Argentina')],
                  classes: 'hero-subtitle',
                ),
                p(
                  [
                    Component.text(
                      'Construyo soluciones full-stack escalables con Flutter (Web/Mobile) y backends robustos. '
                      'De la arquitectura limpia al despliegue en producción: Serverpod, Supabase, Dart Frog, y gestión completa de VPS.',
                    ),
                  ],
                  classes: 'hero-text',
                ),
                div(
                  [
                    a(
                      [Component.text('Ver Proyectos')],
                      href: '#projects',
                      classes: 'button button-primary',
                    ),
                    a(
                      [Component.text('Contactar')],
                      href: '#contact', // Added contact link
                      classes: 'button button-secondary',
                    ),
                  ],
                  classes: 'hero-actions',
                ),
              ],
              classes: 'hero-main',
            ),
            aside(
              [
                div(
                  [
                    h2(
                      [Component.text('Contacto Rápido')],
                      classes: 'info-title',
                    ),
                    dl(
                      [
                        div(
                          [
                            dt(
                              [Component.text('Email')],
                              classes: 'info-label',
                            ),
                            dd(
                              [
                                a(
                                  [Component.text('nicolas.sebastian.estigarribia@gmail.com')],
                                  href: 'mailto:nicolas.sebastian.estigarribia@gmail.com',
                                  classes: 'info-link',
                                ),
                              ],
                              classes: 'info-value',
                            ),
                          ],
                          classes: 'info-row',
                        ),
                        div(
                          [
                            dt(
                              [Component.text('LinkedIn')],
                              classes: 'info-label',
                            ),
                            dd(
                              [
                                a(
                                  [Component.text('/in/nicolas-estigarribia')],
                                  href: 'https://www.linkedin.com/in/nicolas-estigarribia',
                                  target: Target.blank,
                                  classes: 'info-link',
                                  attributes: const {
                                    'rel': 'noopener noreferrer',
                                  },
                                ),
                              ],
                              classes: 'info-value',
                            ),
                          ],
                          classes: 'info-row',
                        ),
                        div(
                          [
                            dt(
                              [Component.text('Ubicación')],
                              classes: 'info-label',
                            ),
                            dd(
                              [Component.text('Argentina (GTM-3)')],
                              classes: 'info-value',
                            ),
                          ],
                          classes: 'info-row',
                        ),
                      ],
                      classes: 'info-list',
                    ),
                  ],
                  classes: 'info-card',
                ),
              ],
              classes: 'hero-aside',
              attributes: const {'aria-label': 'Información rápida'},
            ),
          ],
          classes: 'container hero-inner',
        ),
      ],
      id: 'hero',
      classes: 'hero',
      attributes: const {'aria-labelledby': 'hero-title'},
    );
  }
}

class AboutSection extends StatelessComponent {
  const AboutSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      [
        div(
          [
            div(
              [
                h2(
                  [Component.text('Sobre mí')],
                  id: 'about-title',
                  classes: 'section-title',
                ),
                p(
                  [
                    Component.text(
                      'Desarrollo soluciones end-to-end desde el frontend hasta la infraestructura, '
                      'aplicando Clean Architecture y principios SOLID en cada capa del stack tecnológico.',
                    ),
                  ],
                  classes: 'section-intro',
                ),
              ],
              classes: 'section-header',
            ),
            div(
              [
                div(
                  [
                    p(
                      [
                        Component.text(
                          'En el frontend desarrollo con Flutter para Web y Mobile, utilizando BLoC, Riverpod y Provider para gestión de estado. '
                          'En el backend implemento APIs robustas con Serverpod (ORM integrado), Supabase, y Dart Frog, manejando autenticación JWT, '
                          'WebSockets en tiempo real, y bases de datos PostgreSQL.',
                        ),
                      ],
                    ),
                  ],
                  classes: 'card',
                ),
                div(
                  [
                    p(
                      [
                        Component.text(
                          'Aplico Clean Architecture, SOLID y patrones de diseño para crear código mantenible y escalable. '
                          'En DevOps, administro VPS (Linux), configuro Nginx como proxy inverso, implemento CI/CD con GitHub Actions, '
                          'manejo contenedores Docker, y aseguro aplicaciones con SSL/TLS. Deployment automatizado de principio a fin.',
                        ),
                      ],
                    ),
                  ],
                  classes: 'card',
                ),
              ],
              classes: 'section-content two-column',
            ),
          ],
          classes: 'container section-inner',
        ),
      ],
      id: 'about',
      classes: 'section',
      attributes: const {'aria-labelledby': 'about-title'},
    );
  }
}

class ExperienceSection extends StatelessComponent {
  const ExperienceSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      [
        div(
          [
            div(
              [
                h2(
                  [Component.text('Experiencia')],
                  id: 'experience-title',
                  classes: 'section-title',
                ),
                p(
                  [
                    Component.text(
                      'Trayectoria profesional en desarrollo de software y aplicaciones móviles.',
                    ),
                  ],
                  classes: 'section-intro',
                ),
              ],
              classes: 'section-header',
            ),
            div(
              [
                article(
                  [
                    header(
                      [
                        div(
                          [
                            h3(
                              [Component.text('SSR+ Software Developer')],
                              classes: 'experience-role',
                            ),
                            p(
                              [Component.text('Rubika networking')],
                              classes: 'experience-company',
                            ),
                          ],
                        ),
                        div(
                          [
                            span(
                              [Component.text('marzo de 2025 – Presente')],
                              classes: 'badge',
                            ),
                          ],
                          classes: 'experience-meta',
                        ),
                      ],
                      classes: 'experience-header',
                    ),
                    ul(
                      [
                        li([
                          Component.text(
                            'Desarrollo full-stack: interfaces Flutter (Web/Mobile) y backend con Supabase/PostgreSQL. Implementación de APIs REST, autenticación JWT, y lógica de negocio compleja.',
                          ),
                        ]),
                        li([
                          Component.text(
                            'Resolución de desafíos técnicos complejos, code reviews, y mentoría de desarrolladores junior. Aplicación de Clean Architecture y SOLID en todos los proyectos.',
                          ),
                        ]),
                      ],
                      classes: 'experience-points',
                    ),
                  ],
                  classes: 'experience-item',
                ),
                article(
                  [
                    header(
                      [
                        div(
                          [
                            h3(
                              [Component.text('SSR Flutter Developer')],
                              classes: 'experience-role',
                            ),
                            p(
                              [Component.text('Greelow (Contractor)')],
                              classes: 'experience-company',
                            ),
                          ],
                        ),
                        div(
                          [
                            span(
                              [Component.text('marzo de 2024 – febrero de 2025')],
                              classes: 'badge',
                            ),
                          ],
                          classes: 'experience-meta',
                        ),
                      ],
                      classes: 'experience-header',
                    ),
                    ul(
                      [
                        li([
                          Component.text(
                            'Desarrollo de componentes críticos para app bancaria: autenticación biométrica, transferencias, consulta de saldos, y gestión de tarjetas.',
                          ),
                        ]),
                        li([
                          Component.text(
                            'Implementación de arquitectura escalable con BLoC, integración de APIs RESTful seguras, y optimización de rendimiento para UX fluida.',
                          ),
                        ]),
                      ],
                      classes: 'experience-points',
                    ),
                  ],
                  classes: 'experience-item',
                ),
                article(
                  [
                    header(
                      [
                        div(
                          [
                            h3(
                              [Component.text('JR Software Developer')],
                              classes: 'experience-role',
                            ),
                            p(
                              [Component.text('Digital Express')],
                              classes: 'experience-company',
                            ),
                          ],
                        ),
                        div(
                          [
                            span(
                              [Component.text('sept 2021 – feb 2024')],
                              classes: 'badge',
                            ),
                          ],
                          classes: 'experience-meta',
                        ),
                      ],
                      classes: 'experience-header',
                    ),
                    ul(
                      [
                        li([
                          Component.text(
                            'Desarrollo de apps de transporte y logística con geolocalización GPS, mapas interactivos, y tracking en tiempo real.',
                          ),
                        ]),
                        li([
                          Component.text(
                            'Integración de pasarelas de pago (Stripe, Mercado Pago), consumo de APIs RESTful, y manejo de estados complejos con Provider.',
                          ),
                        ]),
                      ],
                      classes: 'experience-points',
                    ),
                  ],
                  classes: 'experience-item',
                ),
              ],
              classes: 'experience-list',
            ),
          ],
          classes: 'container section-inner',
        ),
      ],
      id: 'experience',
      classes: 'section',
      attributes: const {'aria-labelledby': 'experience-title'},
    );
  }
}

class ProjectsSection extends StatelessComponent {
  const ProjectsSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      [
        div(
          [
            div(
              [
                h2(
                  [Component.text('Proyectos destacados')],
                  id: 'projects-title',
                  classes: 'section-title',
                ),
                p(
                  [
                    Component.text(
                      'Soluciones tecnológicas desarrolladas con estándares de calidad y rendimiento.',
                    ),
                  ],
                  classes: 'section-intro',
                ),
              ],
              classes: 'section-header',
            ),
            div(
              [
                article(
                  [
                    h3(
                      [Component.text('Banco Bineo - App Bancaria')],
                      classes: 'card-title',
                    ),
                    p(
                      [
                        Component.text(
                          'Desarrollo de componentes críticos para aplicación bancaria móvil. Implementación de flujos de autenticación segura, '
                          'gestión de cuentas, transferencias, y animaciones fluidas. Clean Architecture con BLoC para máxima escalabilidad.',
                        ),
                      ],
                      classes: 'card-text',
                    ),
                    p(
                      [
                        strong([Component.text('Stack:')]),
                        Component.text(' Flutter, BLoC, Clean Architecture, JWT, REST APIs'),
                      ],
                      classes: 'card-meta',
                    ),
                  ],
                  classes: 'card',
                ),
                article(
                  [
                    h3(
                      [Component.text('Full-Stack Infrastructure Portfolio')],
                      classes: 'card-title',
                    ),
                    p(
                      [
                        Component.text(
                          'Portfolio web con SSR usando Jaspr (Dart), desplegado en VPS con Nginx, Docker, SSL automático con Let\'s Encrypt, '
                          'y CI/CD con GitHub Actions. Configuración completa de infraestructura desde cero, incluyendo firewall y monitoreo.',
                        ),
                      ],
                      classes: 'card-text',
                    ),
                    p(
                      [
                        strong([Component.text('Stack:')]),
                        Component.text(
                          ' Jaspr SSR, Docker, Nginx, Linux VPS, GitHub Actions, SSL/TLS',
                        ),
                      ],
                      classes: 'card-meta',
                    ),
                  ],
                  classes: 'card',
                ),
                article(
                  [
                    h3(
                      [Component.text('Sistema de Monitoreo en Tiempo Real')],
                      classes: 'card-title',
                    ),
                    p(
                      [
                        Component.text(
                          'Aplicación full-stack con Flutter Web/Mobile + backend Serverpod. WebSockets para actualizaciones en tiempo real, '
                          'PostgreSQL con ORM, autenticación JWT, panel de administración, y deployment en VPS con Docker Compose.',
                        ),
                      ],
                      classes: 'card-text',
                    ),
                    p(
                      [
                        strong([Component.text('Stack:')]),
                        Component.text(
                          ' Flutter, Serverpod, PostgreSQL, WebSockets, Docker, VPS',
                        ),
                      ],
                      classes: 'card-meta',
                    ),
                  ],
                  classes: 'card',
                ),
              ],
              classes: 'card-grid',
            ),
          ],
          classes: 'container section-inner',
        ),
      ],
      id: 'projects',
      classes: 'section',
      attributes: const {'aria-labelledby': 'projects-title'},
    );
  }
}

class SkillsSection extends StatelessComponent {
  const SkillsSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      [
        div(
          [
            div(
              [
                h2(
                  [Component.text('Tech Stack')],
                  id: 'skills-title',
                  classes: 'section-title',
                ),
                p(
                  [
                    Component.text(
                      'Herramientas y tecnologías que domino para construir software de calidad.',
                    ),
                  ],
                  classes: 'section-intro',
                ),
              ],
              classes: 'section-header',
            ),
            div(
              [
                div(
                  [
                    h3(
                      [Component.text('Flutter Development')],
                      classes: 'skills-title',
                    ),
                    div(
                      [
                        span([Component.text('Flutter Web')], classes: 'chip'),
                        span([Component.text('Flutter Mobile')], classes: 'chip'),
                        span([Component.text('Dart')], classes: 'chip'),
                        span([Component.text('Android / iOS')], classes: 'chip'),
                        span([Component.text('Method Channels')], classes: 'chip'),
                        span([Component.text('BLoC')], classes: 'chip'),
                        span([Component.text('Riverpod')], classes: 'chip'),
                        span([Component.text('Provider')], classes: 'chip'),
                      ],
                      classes: 'chip-list',
                    ),
                  ],
                  classes: 'skills-group',
                ),
                div(
                  [
                    h3(
                      [Component.text('Backend & APIs')],
                      classes: 'skills-title',
                    ),
                    div(
                      [
                        span([Component.text('Serverpod + ORM')], classes: 'chip'),
                        span([Component.text('Supabase')], classes: 'chip'),
                        span([Component.text('Dart Frog')], classes: 'chip'),
                        span([Component.text('PostgreSQL')], classes: 'chip'),
                        span([Component.text('REST APIs')], classes: 'chip'),
                        span([Component.text('WebSockets')], classes: 'chip'),
                        span([Component.text('JWT Auth')], classes: 'chip'),
                      ],
                      classes: 'chip-list',
                    ),
                  ],
                  classes: 'skills-group',
                ),
                div(
                  [
                    h3(
                      [Component.text('Architecture')],
                      classes: 'skills-title',
                    ),
                    div(
                      [
                        span([Component.text('Clean Architecture')], classes: 'chip'),
                        span([Component.text('SOLID')], classes: 'chip'),
                        span([Component.text('MVVM')], classes: 'chip'),
                        span([Component.text('Testing')], classes: 'chip'),
                      ],
                      classes: 'chip-list',
                    ),
                  ],
                  classes: 'skills-group',
                ),
                div(
                  [
                    h3(
                      [Component.text('DevOps & Infrastructure')],
                      classes: 'skills-title',
                    ),
                    div(
                      [
                        span([Component.text('Linux VPS Management')], classes: 'chip'),
                        span([Component.text('Nginx + Reverse Proxy')], classes: 'chip'),
                        span([Component.text('Docker & Compose')], classes: 'chip'),
                        span([Component.text('SSL/TLS Certificates')], classes: 'chip'),
                        span([Component.text('CI/CD (GitHub Actions)')], classes: 'chip'),
                        span([Component.text('Bash Scripting')], classes: 'chip'),
                        span([Component.text('Server Security')], classes: 'chip'),
                        span([Component.text('Ubuntu/Debian')], classes: 'chip'),
                      ],
                      classes: 'chip-list',
                    ),
                  ],
                  classes: 'skills-group',
                ),
              ],
              classes: 'skills-grid',
            ),
          ],
          classes: 'container section-inner',
        ),
      ],
      id: 'skills',
      classes: 'section',
      attributes: const {'aria-labelledby': 'skills-title'},
    );
  }
}

class EducationSection extends StatelessComponent {
  const EducationSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      [
        div(
          [
            div(
              [
                h2(
                  [Component.text('Educación y certificaciones')],
                  id: 'education-title',
                  classes: 'section-title',
                ),
              ],
              classes: 'section-header',
            ),
            div(
              [
                div(
                  [
                    h3(
                      [Component.text('Educación')],
                      classes: 'subsection-title',
                    ),
                    article(
                      [
                        h4(
                          [
                            Component.text(
                              'Tecnicatura Superior en Desarrollo de Software',
                            ),
                          ],
                          classes: 'education-degree',
                        ),
                        p(
                          [Component.text('Instituto Superior Goya')],
                          classes: 'education-institution',
                        ),
                        p(
                          [Component.text('2019 – 2021')],
                          classes: 'education-meta',
                        ),
                      ],
                      classes: 'education-item',
                    ),
                  ],
                  classes: 'section-column',
                ),
                div(
                  [
                    h3(
                      [Component.text('Certificaciones')],
                      classes: 'subsection-title',
                    ),
                    ul(
                      [
                        li([Component.text('Flutter Web: Aplicaciones profesionales')]),
                        li([Component.text('Flutter Avanzado')]),
                        li([Component.text('Nuxt, NodeJS, SQL')]),
                        li([Component.text('Flutter Móvil: de Cero a Experto')]),
                        li([Component.text('SQL y Bases de datos')]),
                      ],
                      classes: 'list',
                    ),
                  ],
                  classes: 'section-column',
                ),
              ],
              classes: 'two-column',
            ),
          ],
          classes: 'container section-inner',
        ),
      ],
      id: 'education',
      classes: 'section',
      attributes: const {'aria-labelledby': 'education-title'},
    );
  }
}

class ContactSection extends StatelessComponent {
  const ContactSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      [
        div(
          [
            div(
              [
                h2(
                  [Component.text('Contacto')],
                  id: 'contact-title',
                  classes: 'section-title',
                ),
                p(
                  [
                    Component.text(
                      '¿Tienes un proyecto en mente? Hablemos.',
                    ),
                  ],
                  classes: 'section-intro',
                ),
              ],
              classes: 'section-header',
            ),
            div(
              [
                div(
                  [
                    p([
                      strong([Component.text('Email:')]),
                      Component.text(' '),
                      a(
                        [Component.text('nicolas.sebastian.estigarribia@gmail.com')],
                        href: 'mailto:nicolas.sebastian.estigarribia@gmail.com',
                      ),
                    ]),
                    p([
                      strong([Component.text('LinkedIn:')]),
                      Component.text(' '),
                      a(
                        [Component.text('linkedin.com/in/nicolas-estigarribia')],
                        href: 'https://www.linkedin.com/in/nicolas-estigarribia',
                        target: Target.blank,
                        attributes: const {
                          'rel': 'noopener noreferrer',
                        },
                      ),
                    ]),
                  ],
                  classes: 'contact-details',
                ),
                div(
                  [
                    a(
                      [Component.text('Envíame un Email')],
                      href: 'mailto:nicolas.sebastian.estigarribia@gmail.com',
                      classes: 'button button-primary button-wide',
                    ),
                    a(
                      [Component.text('LinkedIn')],
                      href: 'https://www.linkedin.com/in/nicolas-estigarribia',
                      target: Target.blank,
                      classes: 'button button-secondary button-wide',
                      attributes: const {
                        'rel': 'noopener noreferrer',
                      },
                    ),
                  ],
                  classes: 'contact-buttons',
                ),
              ],
              classes: 'contact-actions',
            ),
          ],
          classes: 'container section-inner contact-inner',
        ),
      ],
      id: 'contact',
      classes: 'section section-accent',
      attributes: const {'aria-labelledby': 'contact-title'},
    );
  }
}

class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return footer(
      [
        div(
          [
            p(
              [
                Component.text('© 2026 Nicolas Estigarribia. Construido con Flutter Web & Jaspr.'),
              ],
              classes: 'footer-text',
            ),
          ],
          classes: 'container footer-inner',
        ),
      ],
      classes: 'site-footer',
    );
  }
}
