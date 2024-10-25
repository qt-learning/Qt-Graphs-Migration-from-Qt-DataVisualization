#include <QtDataVisualization/qutils.h>
#include <QtGui/qguiapplication.h>
#include <QtQml/qqmlengine.h>
#include <QtQuick/qquickview.h>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[])
{
    // This is a mandatory addition with QtDataVisualization
    qputenv("QSG_RHI_BACKEND", "opengl");

    QGuiApplication app(argc, argv);

    QQuickView viewer;
    QObject::connect(viewer.engine(), &QQmlEngine::quit, &viewer, &QWindow::close);

    // Enable antialiasing in direct rendering mode
    viewer.setFormat(qDefaultSurfaceFormat(true));

    viewer.setTitle("Hello Qt Academy with QtDataVisualization!");
    viewer.setColor(QColor("black"));

    viewer.setSource(QUrl(u"qrc:/Main.qml"_s));
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.show();

    return app.exec();
}
