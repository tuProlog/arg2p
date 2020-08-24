package alice.tuprologx.ide;

import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Struct;
import com.google.common.collect.ImmutableMap;
import edu.uci.ics.jung.algorithms.layout.KKLayout;
import edu.uci.ics.jung.algorithms.layout.Layout;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.SparseMultigraph;
import edu.uci.ics.jung.graph.util.EdgeType;
import edu.uci.ics.jung.visualization.VisualizationViewer;
import edu.uci.ics.jung.visualization.control.DefaultModalGraphMouse;
import edu.uci.ics.jung.visualization.control.ModalGraphMouse;
import edu.uci.ics.jung.visualization.decorators.ToStringLabeller;
import edu.uci.ics.jung.visualization.renderers.Renderer;

import javax.swing.*;
import java.awt.*;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ArgumentationGraphFrame {

    public static final String BUILD_LABEL_SETS = "buildLabelSets";
    private final JScrollPane argumentationGraph;
    private Map<String, List<String>> vertices;

    public ArgumentationGraphFrame(JScrollPane argumentationGraph) {
        this.argumentationGraph = argumentationGraph;
    }

    @SuppressWarnings("rawtypes")
    public void printGraph(SolveInfo info, Prolog engine) {

        if (!(info.getQuery().toString().startsWith(BUILD_LABEL_SETS)
                && info.isSuccess())) {
            argumentationGraph.getViewport().removeAll();
            return;
        }

        final Layout<String, String> layout = new KKLayout<>(buildGraph(engine));
        layout.setSize(new Dimension(500,500));

        final VisualizationViewer<String, String> vv = new VisualizationViewer<>(layout);
        vv.setPreferredSize(new Dimension(500,500));
        vv.getRenderContext().setVertexFillPaintTransformer(i -> {
            if (this.vertices.get("in").contains(i)) return Color.GREEN;
            if (this.vertices.get("out").contains(i)) return Color.RED;
            return Color.GRAY;
        });
        vv.getRenderContext().setVertexLabelTransformer(new ToStringLabeller());
        vv.getRenderer().getVertexLabelRenderer().setPosition(Renderer.VertexLabel.Position.AUTO);

        final DefaultModalGraphMouse graphMouse = new DefaultModalGraphMouse();
        graphMouse.setMode(ModalGraphMouse.Mode.PICKING);
        vv.setGraphMouse(graphMouse);

        argumentationGraph.getViewport().setView(vv);
    }

    private Graph<String, String> buildGraph(Prolog engine) {

        final Struct labelling = engine.getTheory()
            .getClauses().stream()
            .filter(x -> x.match(engine.termSolve("argsLabelling(X, Y, Z)")))
            .map(x -> (Struct) x)
            .findAny()
            .orElseThrow(IllegalStateException::new);

        this.vertices = ImmutableMap.of(
            "in", parseLabellingArg(labelling,0),
            "out", parseLabellingArg(labelling,1),
            "und", parseLabellingArg(labelling,2)
        );

        final Graph<String, String> graph = new SparseMultigraph<>();

        this.vertices.entrySet().stream()
                .flatMap(x -> x.getValue().stream())
                .forEach(graph::addVertex);

        engine.getTheory()
            .getClauses().stream()
            .filter(x -> x.match(engine.termSolve("attack(X, Y)")))
            .forEach(x -> {
                List<String> r = regexResults(x.toString());
                graph.addEdge(r.get(0).concat(r.get(1)), r.get(0), r.get(1), EdgeType.DIRECTED);
            });

        return graph;
    }

    private List<String> parseLabellingArg(Struct labelling, int index) {
        return regexResults(labelling.getArg(index)
                .toString().replaceAll("^.|.$", ""));
    }

    private List<String> regexResults(String target) {
        final List<String> matches = new LinkedList<>();
        final Matcher m = Pattern
                .compile("(?<=\\[\\[).*?(?=\\])")
                .matcher(target);

        while(m.find()) {
            matches.add(m.group());
        }
        return matches;
    }
}
