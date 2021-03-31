/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class TimeStamp {

  /* Members */

  private int value;

  /* Constructors */

  public TimeStamp(int value) {
    this.value = value;
  }

  public TimeStamp() {
    this.value = 0;
  }

  public TimeStamp(TimeStamp other) {
    this.value = other.value;
  }

  /* Accessors and mutators */

  public int getValue() {
    return value;
  }

  public void setValue(int value) {
    this.value = value;
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof TimeStamp)) {
      return false;
    }
    TimeStamp other = (TimeStamp) other0;
    return
      value == other.value;
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + value;
    return _result;
  }

  /* Factory for construction of generic values */

  public static final Factory<TimeStamp> FACTORY = new Factory<TimeStamp>() {
    @Override
    public TimeStamp create() {
      return new TimeStamp();
    }

    @Override
    public TimeStamp create(TimeStamp other) {
      return new TimeStamp(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "TimeStamp");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<TimeStamp> jsonBinding() {
      return TimeStamp.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<TimeStamp> jsonBinding() {
    final JsonBinding<Integer> _binding = JsonBindings.WORD32;
    final Factory<TimeStamp> _factory = FACTORY;

    return new JsonBinding<TimeStamp>() {
      @Override
      public Factory<TimeStamp> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(TimeStamp _value) {
        return _binding.toJson(_value.value);
      }

      @Override
      public TimeStamp fromJson(JsonElement _json) {
        return new TimeStamp(_binding.fromJson(_json));
      }
    };
  }
}
