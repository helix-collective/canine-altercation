/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Builders;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class WithTimeStamp<T> {

  /* Members */

  private TimeStamp t;
  private T value;

  /* Constructors */

  public WithTimeStamp(TimeStamp t, T value) {
    this.t = Objects.requireNonNull(t);
    this.value = Objects.requireNonNull(value);
  }

  /* Accessors and mutators */

  public TimeStamp getT() {
    return t;
  }

  public void setT(TimeStamp t) {
    this.t = Objects.requireNonNull(t);
  }

  public T getValue() {
    return value;
  }

  public void setValue(T value) {
    this.value = Objects.requireNonNull(value);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof WithTimeStamp)) {
      return false;
    }
    WithTimeStamp<?> other = (WithTimeStamp<?>) other0;
    return
      t.equals(other.t) &&
      value.equals(other.value);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + t.hashCode();
    _result = _result * 37 + value.hashCode();
    return _result;
  }

  /* Builder */

  public static class Builder<T> {
    private TimeStamp t;
    private T value;

    public Builder() {
      this.t = null;
      this.value = null;
    }

    public Builder<T> setT(TimeStamp t) {
      this.t = Objects.requireNonNull(t);
      return this;
    }

    public Builder<T> setValue(T value) {
      this.value = Objects.requireNonNull(value);
      return this;
    }

    public WithTimeStamp<T> create() {
      Builders.checkFieldInitialized("WithTimeStamp", "t", t);
      Builders.checkFieldInitialized("WithTimeStamp", "value", value);
      return new WithTimeStamp<T>(t, value);
    }
  }

  /* Factory for construction of generic values */

  public static <T> Factory<WithTimeStamp<T>> factory(Factory<T> factoryT) {
    return new Factory<WithTimeStamp<T>>() {
      final Lazy<Factory<TimeStamp>> t = new Lazy<>(() -> TimeStamp.FACTORY);
      final Lazy<Factory<T>> value = new Lazy<>(() -> factoryT);

      @Override
      public WithTimeStamp<T> create() {
        return new WithTimeStamp<T>(
          t.get().create(),
          value.get().create()
          );
      }

      @Override
      public WithTimeStamp<T> create(WithTimeStamp<T> other) {
        return new WithTimeStamp<T>(
          t.get().create(other.getT()),
          value.get().create(other.getValue())
          );
      }

      @Override
      public TypeExpr typeExpr() {
        ScopedName scopedName = new ScopedName("canine.api", "WithTimeStamp");
        ArrayList<TypeExpr> params = new ArrayList<>();
        params.add(factoryT.typeExpr());
        return new TypeExpr(TypeRef.reference(scopedName), params);
      }

      @Override
      public JsonBinding<WithTimeStamp<T>> jsonBinding() {
        return WithTimeStamp.jsonBinding(factoryT.jsonBinding());
      }
    };
  }

  /* Json serialization */

  public static<T> JsonBinding<WithTimeStamp<T>> jsonBinding(JsonBinding<T> bindingT) {
    final Lazy<JsonBinding<TimeStamp>> t = new Lazy<>(() -> TimeStamp.jsonBinding());
    final Lazy<JsonBinding<T>> value = new Lazy<>(() -> bindingT);
    final Factory<T> factoryT = bindingT.factory();
    final Factory<WithTimeStamp<T>> _factory = factory(bindingT.factory());

    return new JsonBinding<WithTimeStamp<T>>() {
      @Override
      public Factory<WithTimeStamp<T>> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(WithTimeStamp<T> _value) {
        JsonObject _result = new JsonObject();
        _result.add("t", t.get().toJson(_value.t));
        _result.add("value", value.get().toJson(_value.value));
        return _result;
      }

      @Override
      public WithTimeStamp<T> fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new WithTimeStamp<T>(
          JsonBindings.fieldFromJson(_obj, "t", t.get()),
          JsonBindings.fieldFromJson(_obj, "value", value.get())
        );
      }
    };
  }
}
