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
                  [Component.text('Dev Flutter | Dart | PostgreSQL')],
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
                  [Component.text('Desarrollador Flutter')],
                  classes: 'hero-kicker',
                ),
                h1(
                  [Component.text('Nicolas Estigarribia')],
                  id: 'hero-title',
                  classes: 'hero-title gradient-text', // Added gradient-text
                ),
                p(
                  [Component.text('Ingeniería móvil de alto impacto · Argentina')],
                  classes: 'hero-subtitle',
                ),
                p(
                  [
                    Component.text(
                      'Transformo ideas complejas en experiencias móviles fluidas y escalables con Flutter. '
                      'Especializado en arquitectura limpia, rendimiento y diseño de interfaces premium.',
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
                      'Creo experiencias móviles centradas en las personas, combinando un alto rendimiento con una arquitectura sólida '
                      'y un enfoque constante en la calidad del código.',
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
                          'Cuento con experiencia en el consumo de APIs RESTful, almacenamiento seguro de datos y autenticación mediante '
                          'JWT y Refresh Tokens. He desarrollado widgets personalizados y plugins a medida, trabajando con arquitecturas '
                          'de gestión de estado como BLoC, Provider y Riverpod.',
                        ),
                      ],
                    ),
                  ],
                  classes: 'card', // Added card class for background
                ),
                div(
                  [
                    p(
                      [
                        Component.text(
                          'Aplico principios de Clean Code y patrones de diseño como Clean Architecture, Model-View (MV) y Model-View-ViewModel (MVVM), '
                          'apoyándome en pruebas unitarias, de widgets y de integración para garantizar estabilidad y mantenibilidad.',
                        ),
                      ],
                    ),
                  ],
                  classes: 'card', // Added card class for background
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
                            'Desarrollo full-stack de interfaces en Flutter y lógica de backend utilizando Supabase y PostgreSQL.',
                          ),
                        ]),
                        li([
                          Component.text(
                            'Resolución de desafíos técnicos y aseguramiento de la calidad del código, colaborando con desarrolladores junior.',
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
                            'Desarrollo de widgets y pantallas fundamentales para la aplicación Banco de Barone.',
                          ),
                        ]),
                        li([
                          Component.text(
                            'Implementación de nuevas funcionalidades y mantenimiento de código legacy.',
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
                            'Desarrollo de proyectos de transporte y logística, geolocalización y mapas.',
                          ),
                        ]),
                        li([
                          Component.text(
                            'Integración de pasares de pagos como Stripe y Mercado Pago.',
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
                      [Component.text('Banco Bineo')],
                      classes: 'card-title',
                    ),
                    p(
                      [
                        Component.text(
                          'Desarrollo de componentes críticos para la aplicación bancaria, asegurando seguridad y fluidez en transacciones.',
                        ),
                      ],
                      classes: 'card-text',
                    ),
                    p(
                      [
                        strong([Component.text('Stack:')]),
                        Component.text(' Flutter, BLoC, Clean Arch.'),
                      ],
                      classes: 'card-meta',
                    ),
                  ],
                  classes: 'card',
                ),
                article(
                  [
                    h3(
                      [Component.text('Logística & Mapas')],
                      classes: 'card-title',
                    ),
                    p(
                      [
                        Component.text(
                          'App de gestión de envíos con geolocalización en tiempo real y optimización de rutas.',
                        ),
                      ],
                      classes: 'card-text',
                    ),
                    p(
                      [
                        strong([Component.text('Stack:')]),
                        Component.text(
                          ' Flutter, Google Maps, APIs REST.',
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
                      [Component.text('E-commerce Móvil')],
                      classes: 'card-title',
                    ),
                    p(
                      [
                        Component.text(
                          'Plataforma de compras con experiencia de usuario premium y animaciones fluidas.',
                        ),
                      ],
                      classes: 'card-text',
                    ),
                    p(
                      [
                        strong([Component.text('Stack:')]),
                        Component.text(
                          ' Flutter, Riverpod, Stripe.',
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
                      [Component.text('Mobile Development')],
                      classes: 'skills-title',
                    ),
                    div(
                      [
                        span([Component.text('Flutter')], classes: 'chip'),
                        span([Component.text('Dart')], classes: 'chip'),
                        span([Component.text('Android / iOS')], classes: 'chip'),
                        span([Component.text('Method Channels')], classes: 'chip'),
                      ],
                      classes: 'chip-list',
                    ),
                  ],
                  classes: 'skills-group',
                ),
                div(
                  [
                    h3(
                      [Component.text('State Management')],
                      classes: 'skills-title',
                    ),
                    div(
                      [
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
                      [Component.text('Backend & Data')],
                      classes: 'skills-title',
                    ),
                    div(
                      [
                        span([Component.text('PostgreSQL')], classes: 'chip'),
                        span([Component.text('Supabase')], classes: 'chip'),
                        span([Component.text('Node.js')], classes: 'chip'),
                        span([Component.text('APIs REST')], classes: 'chip'),
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
                      [Component.text('Infrastructure & DevOps')],
                      classes: 'skills-title',
                    ),
                    div(
                      [
                        span([Component.text('Docker & Compose')], classes: 'chip'),
                        span([Component.text('Nginx Web Server')], classes: 'chip'),
                        span([Component.text('Linux / VPS Admin')], classes: 'chip'),
                        span([Component.text('CI/CD Pipelines')], classes: 'chip'),
                        span([Component.text('Bash Scripting')], classes: 'chip'),
                        span([Component.text('SSL / Let\'s Encrypt')], classes: 'chip'),
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
