#include <QtCore/QCoreApplication>
#include <QtCore/QDir>
#include <QtCore/QLocale>
#include <QtCore/QStandardPaths>
#include <QtCore/QString>
#include <QtCore/QTranslator>
#include <QtGui/QFontDatabase>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQuickControls2/QQuickStyle>
#include <QtQml/qqml.h>
#include <QScreen>
#include <QVersionNumber>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QtAndroid>
#include <QtAndroidExtras/QAndroidJniObject>
#include <QtAndroidExtras/QAndroidJniEnvironment>
#endif

#ifdef QT_DEBUG
#include <QDirIterator>
#endif



void createAppConfigFolder()
{
    QDir dirConfig(
                QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation));
#ifdef QT_DEBUG
    qDebug() << "dirConfig.path()" << dirConfig.path();
#endif
    if (dirConfig.exists() == false) {
        dirConfig.mkpath(dirConfig.path());
    }
}

const QString getAppFont(){
    QStringList font_families;

    int id = QFontDatabase::addApplicationFont(":/res/fonts/PT-Astra-Serif_Regular.ttf");

    if(id != -1){
        font_families = QFontDatabase::applicationFontFamilies(id);
    }else{
        QFont font;
        font_families << font.defaultFamily();
    }

#ifdef QT_DEBUG
    qDebug() << "font:" <<font_families.first();
#endif

    return font_families.first();
}

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QCoreApplication::setOrganizationName("ZanyXDev");
    QCoreApplication::setApplicationName("UnRiddle");
    QCoreApplication::setApplicationVersion(
                QString("%1.%2").arg(VERSION).arg(GIT_HASH));

    ///TODO usage QVersionNumber version(1, 2, 3);

    QGuiApplication app(argc, argv);

    /*!
     * \brief Make docs encourage readers to query locale right
     * \sa https://codereview.qt-project.org/c/qt/qtdoc/+/297560
     */
    // create folder AppConfigLocation
    createAppConfigFolder();

    QTranslator myappTranslator;
    myappTranslator.load(QLocale(), QLatin1String("unriddle"), QLatin1String("_"),
                         QLatin1String(":/i18n"));
    app.installTranslator(&myappTranslator);

    QQuickStyle::setStyle("Material");

    int density = 0;
    bool isMobile = false;
    /// TODO replace +android folder
    const QUrl url(QStringLiteral("qrc:/res/qml/main.qml"));

#ifdef Q_OS_ANDROID
    //  BUG with dpi on some androids: https://bugreports.qt-project.org/browse/QTBUG-35701
    // density = QtAndroid::androidActivity().callMethod<jint>("getScreenDpi");

    QtAndroid::hideSplashScreen();

    isMobile = true;
    float logicalDensity = 0;
    float yDpi = 0;
    float xDpi = 0;

    QAndroidJniEnvironment env;
    //  BUG with dpi on some androids: https://bugreports.qt-project.org/browse/QTBUG-35701
    QAndroidJniObject qtActivity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    if (env->ExceptionCheck()) {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return EXIT_FAILURE;
    }
    QAndroidJniObject resources = qtActivity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");
    if (env->ExceptionCheck()) {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return EXIT_FAILURE;
    }
    QAndroidJniObject displayMetrics = resources.callObjectMethod("getDisplayMetrics", "()Landroid/util/DisplayMetrics;");

    if (env->ExceptionCheck()) {
        env->ExceptionDescribe();
        env->ExceptionClear();
        return EXIT_FAILURE;
    }

    density = displayMetrics.getField<int>("densityDpi");
    logicalDensity = displayMetrics.getField<float>("density");
    yDpi = displayMetrics.getField<float>("ydpi");
    xDpi = displayMetrics.getField<float>("xdpi");

    qDebug() << "Native destop app =>>>";
    qDebug() << "DensityDPI: " << density << " | "
             << "Logical Density: " << logicalDensity << " | "
             << "yDpi: " << yDpi  << " | "
             << "xDpi: " << xDpi ;
    qDebug() << "++++++++++++++++++++++++";
#else
    QScreen *screen = qApp->primaryScreen();
    density = screen->physicalDotsPerInch() * screen->devicePixelRatio();

#ifdef QT_DEBUG
    qDebug() << "Native destop app =>>>";
    qDebug() << "DensityDPI: " << density << " | "
             << "physicalDPI: " << screen->physicalDotsPerInch() << " | "
             << "devicePixelRatio(): " << screen->devicePixelRatio();
    qDebug() << "++++++++++++++++++++++++";
#endif

#endif

    double scale = density >= 640 ? 4 :
                                    density >= 480 ? 3 :
                                                     density >= 320 ? 2 :
                                                                      density >= 240 ? 1.5 : 1;

    // allocate monitor before the engine to ensure that it outlives it
    // QScopedPointer<Monitor> monitor(new Monitor);

    ///TODO release https://code.qt.io/cgit/qt/qtandroidextras.git/tree/examples/androidextras/customactivity?h=5.15
    QQmlApplicationEngine engine;

    engine.addImportPath(":/res/qml");

#ifdef QT_DEBUG
    scale = 1.75;
    QDirIterator it(":", QDirIterator::Subdirectories);
    while (it.hasNext()) {
        qDebug() << it.next();
    }
#endif

    QQmlContext *context = engine.rootContext();
    context->setContextProperty("mm",density / 25.4);
    context->setContextProperty("pt", 1);
    context->setContextProperty("DevicePixelRatio", scale);
    context->setContextProperty("isMobile",isMobile);
    context->setContextProperty("font_families",getAppFont() );
#ifdef QT_DEBUG
    context->setContextProperty("isDebugMode",true );
#endif
    QObject::connect(
                &engine, &QQmlApplicationEngine::objectCreated, &app,
                [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) QCoreApplication::exit(-1);
    },
    Qt::QueuedConnection);

    // Third, register the singleton type provider with QML by calling this
    // function in an initialization function.
    //  qmlRegisterSingletonInstance("io.github.zanyxdev.qml_hwmonitor", 1, 0, "Monitor", monitor.get());

    engine.load(url);

    return app.exec();
}
