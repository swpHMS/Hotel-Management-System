package utils;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class EmailExecutor {
    private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(2);

    public static void submit(Runnable task) {
        EXECUTOR.submit(task);
    }
}